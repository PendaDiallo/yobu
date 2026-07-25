<?php

namespace Tests\Feature;

use App\Models\Booking;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

/**
 * LE test du projet (docs/02-technique.md §4) : un matching qui « marche
 * presque » est invisible à l'œil et fatal au produit.
 *
 * Géométrie de test : une route EST-OUEST le long de la latitude 14.70
 * (LINESTRING(-17.40 14.70, -17.30 14.70)). Un décalage de latitude est
 * donc une distance perpendiculaire exacte : 0.01266° ≈ 1 400 m,
 * 0.01447° ≈ 1 600 m (1° de latitude ≈ 110.57 km).
 */
class TripMatchingTest extends TestCase
{
    use RefreshDatabase;

    private const ROUTE_EAST_WEST =
        'LINESTRING(-17.40000 14.70000, -17.30000 14.70000)';

    /** Lundi prochain — les trajets de test roulent lun-ven. */
    private function nextMonday(): string
    {
        return now()->next('Monday')->toDateString();
    }

    private function makeTrip(array $overrides = []): Trip
    {
        return Trip::factory()->create([
            'route' => self::ROUTE_EAST_WEST,
            'dest_point' => 'POINT(-17.30000 14.70000)', // fin de ligne
            'departure_time' => '06:45',
            'duration_minutes' => 60, // arrivée estimée : 07:45
            'days_of_week' => [1, 2, 3, 4, 5],
            'seats_total' => 3,
            'price_per_seat' => 1000,
            ...$overrides,
        ]);
    }

    /** @return array<string, mixed> */
    private function searchPayload(array $overrides = []): array
    {
        return [
            // Passager pile sur la route, destination pile sur la fin de ligne.
            'origin_lat' => 14.70000,
            'origin_lng' => -17.35000,
            'dest_lat' => 14.70000,
            'dest_lng' => -17.30000,
            'arrival_before' => '08:00',
            'date' => $this->nextMonday(),
            ...$overrides,
        ];
    }

    private function search(array $payload = []): \Illuminate\Testing\TestResponse
    {
        $rider = User::factory()->create();

        return $this->postJson(
            '/api/trips/search',
            $this->searchPayload($payload),
            ['Authorization' => 'Bearer '.$rider->createToken('t')->plainTextToken],
        );
    }

    public function test_a_rider_exactly_on_the_route_matches(): void
    {
        $trip = $this->makeTrip();

        $response = $this->search();

        $response->assertOk()->assertJsonCount(1, 'data');
        $match = $response->json('data.0');
        $this->assertSame($trip->id, $match['trip']['id']);
        $this->assertLessThan(50, $match['pickup_distance_m']);
        $this->assertSame(3, $match['trip']['seats_left']);
        $this->assertSame('06:45', $match['trip']['departure_time']);
        $this->assertSame('07:45', $match['trip']['arrival_time']);
    }

    public function test_a_rider_1400m_away_matches(): void
    {
        $this->makeTrip();

        $response = $this->search(['origin_lat' => 14.71266]); // ≈ 1 400 m

        $response->assertOk()->assertJsonCount(1, 'data');
        $this->assertEqualsWithDelta(
            1400,
            $response->json('data.0.pickup_distance_m'),
            30,
        );
    }

    public function test_a_rider_1600m_away_is_excluded(): void
    {
        $this->makeTrip();

        $this->search(['origin_lat' => 14.71447]) // ≈ 1 600 m
            ->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_arriving_19_minutes_late_still_matches(): void
    {
        // Arrivée estimée 07:45, demandé avant 07:26 → +19 min de tolérance.
        $this->makeTrip();

        $this->search(['arrival_before' => '07:26'])
            ->assertOk()->assertJsonCount(1, 'data');
    }

    public function test_arriving_21_minutes_late_is_excluded(): void
    {
        // Arrivée estimée 07:45, demandé avant 07:24 → +21 min : trop tard.
        $this->makeTrip();

        $this->search(['arrival_before' => '07:24'])
            ->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_a_full_trip_on_that_date_is_excluded(): void
    {
        $trip = $this->makeTrip(['seats_total' => 2]);
        Booking::factory()->count(2)->accepted()->create([
            'trip_id' => $trip->id,
            'date' => $this->nextMonday(),
        ]);

        $this->search()->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_a_partially_booked_trip_shows_remaining_seats(): void
    {
        $trip = $this->makeTrip(['seats_total' => 3]);
        Booking::factory()->accepted()->create([
            'trip_id' => $trip->id,
            'date' => $this->nextMonday(),
        ]);
        // Une réservation un AUTRE jour ne compte pas : les places sont par date.
        Booking::factory()->accepted()->create([
            'trip_id' => $trip->id,
            'date' => now()->next('Tuesday')->toDateString(),
        ]);

        $this->search()
            ->assertOk()
            ->assertJsonPath('data.0.trip.seats_left', 2);
    }

    public function test_no_result_returns_an_empty_list(): void
    {
        $this->makeTrip();

        // Une recherche à Guédiawaye, loin du corridor de test.
        $this->search([
            'origin_lat' => 14.77000,
            'origin_lng' => -17.40000,
            'dest_lat' => 14.77000,
            'dest_lng' => -17.39000,
        ])->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_a_trip_not_running_that_day_is_excluded(): void
    {
        $this->makeTrip(['days_of_week' => [6]]); // samedi seulement

        $this->search()->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_an_inactive_trip_is_excluded(): void
    {
        $this->makeTrip(['active' => false]);

        $this->search()->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_results_are_scored_closest_and_cheapest_first(): void
    {
        // Même conducteur ? Non : deux conducteurs, mêmes horaires.
        // Trajet A : passager à ~550 m, 1 000 F. Trajet B : pile dessus mais
        // décalé plus cher — A gagne sur la distance ? Non : B est à 0 m.
        // On vérifie simplement que le score ordonne B (0 m, 1 000 F)
        // devant A (~1 100 m, 1 400 F) : plus proche ET moins cher.
        $far = $this->makeTrip([
            'route' => 'LINESTRING(-17.40000 14.71000, -17.30000 14.71000)',
            'dest_point' => 'POINT(-17.30000 14.71000)', // ~1 100 m du point demandé
            'price_per_seat' => 1400,
        ]);
        $near = $this->makeTrip(['price_per_seat' => 1000]);

        $response = $this->search();

        $response->assertOk()->assertJsonCount(2, 'data');
        $this->assertSame($near->id, $response->json('data.0.trip.id'));
        $this->assertSame($far->id, $response->json('data.1.trip.id'));
        $this->assertGreaterThan(
            $response->json('data.1.score'),
            $response->json('data.0.score'),
        );
    }

    public function test_at_most_ten_results_come_back(): void
    {
        for ($i = 0; $i < 12; $i++) {
            $this->makeTrip();
        }

        $this->search()->assertOk()->assertJsonCount(10, 'data');
    }

    public function test_search_never_calls_google(): void
    {
        Http::fake();
        $this->makeTrip();

        $this->search()->assertOk();

        Http::assertNothingSent();
    }

    public function test_search_requires_authentication(): void
    {
        $this->postJson('/api/trips/search', $this->searchPayload())
            ->assertUnauthorized();
    }
}
