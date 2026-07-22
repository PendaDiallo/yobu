<?php

namespace Tests\Feature;

use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class TripTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Polyline d'exemple de la doc Google :
     * (38.5, -120.2) → (40.7, -120.95) → (43.252, -126.453).
     */
    private const POLYLINE = '_p~iF~ps|U_ulLnnqC_mqNvxq`@';

    private function fakeRoutesApi(): void
    {
        config(['services.google_maps.key' => 'test-key']);
        Http::fake([
            'routes.googleapis.com/*' => Http::response([
                'routes' => [[
                    'duration' => '1860s',
                    'polyline' => ['encodedPolyline' => self::POLYLINE],
                ]],
            ]),
        ]);
    }

    private function authed(User $user): array
    {
        return ['Authorization' => 'Bearer '.$user->createToken('t')->plainTextToken];
    }

    /** @return array<string, mixed> */
    private function payload(): array
    {
        return [
            'origin_label' => 'Keur Massar, Unité 15',
            'origin_lat' => 14.787,
            'origin_lng' => -17.315,
            'dest_label' => 'Plateau, Place de l\'Indépendance',
            'dest_lat' => 14.669,
            'dest_lng' => -17.437,
            'departure_time' => '06:45',
            'days_of_week' => [1, 2, 3, 4, 5],
            'seats_total' => 3,
            'price_per_seat' => 1000,
        ];
    }

    public function test_a_driver_can_publish_a_trip_with_route_from_google(): void
    {
        $this->fakeRoutesApi();
        $driver = User::factory()->driver()->create();

        $response = $this->postJson('/api/trips', $this->payload(), $this->authed($driver));

        $response->assertCreated()
            ->assertJsonPath('data.departure_time', '06:45')
            ->assertJsonPath('data.duration_minutes', 31)
            ->assertJsonPath('data.days_of_week', [1, 2, 3, 4, 5])
            ->assertJsonPath('data.origin.lat', 14.787)
            ->assertJsonPath('data.active', true);

        // La polyline est bien devenue une LineString PostGIS.
        $route = DB::selectOne(
            'SELECT ST_NPoints(route::geometry) AS points,
                    ST_Y(ST_StartPoint(route::geometry)) AS first_lat
             FROM trips LIMIT 1',
        );
        $this->assertSame(3, $route->points);
        $this->assertEqualsWithDelta(38.5, $route->first_lat, 0.0001);

        // UNE SEULE fois — c'est la règle.
        Http::assertSentCount(1);
    }

    public function test_a_rider_cannot_publish_a_trip(): void
    {
        $this->fakeRoutesApi();
        $rider = User::factory()->create(); // role rider

        $this->postJson('/api/trips', $this->payload(), $this->authed($rider))
            ->assertForbidden();

        Http::assertNothingSent();
    }

    public function test_days_of_week_are_validated(): void
    {
        $this->fakeRoutesApi();
        $driver = User::factory()->driver()->create();

        $this->postJson(
            '/api/trips',
            [...$this->payload(), 'days_of_week' => [0, 8]],
            $this->authed($driver),
        )->assertUnprocessable();

        Http::assertNothingSent();
    }

    public function test_mine_returns_only_my_trips(): void
    {
        $mine = Trip::factory()->create();
        Trip::factory()->count(2)->create();

        $response = $this->getJson('/api/trips/mine', $this->authed($mine->driver));

        $response->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $mine->id);
    }

    public function test_a_stranger_cannot_toggle_or_delete_someone_elses_trip(): void
    {
        $trip = Trip::factory()->create();
        $stranger = User::factory()->driver()->create();

        $this->patchJson("/api/trips/{$trip->id}", ['active' => false],
            $this->authed($stranger))->assertForbidden();
        $this->deleteJson("/api/trips/{$trip->id}", [],
            $this->authed($stranger))->assertForbidden();
    }

    public function test_the_driver_can_toggle_then_delete_their_trip(): void
    {
        $trip = Trip::factory()->create();

        $this->patchJson("/api/trips/{$trip->id}", ['active' => false],
            $this->authed($trip->driver))
            ->assertOk()
            ->assertJsonPath('data.active', false);

        $this->deleteJson("/api/trips/{$trip->id}", [],
            $this->authed($trip->driver))->assertNoContent();
        $this->assertDatabaseMissing('trips', ['id' => $trip->id]);
    }

    public function test_price_hint_answers_without_calling_google(): void
    {
        Http::fake();
        $user = User::factory()->create();

        $response = $this->getJson(
            '/api/trips/price-hint?origin=14.787,-17.315&destination=14.669,-17.437',
            $this->authed($user),
        );

        $response->assertOk()->assertJsonStructure(['min', 'suggested', 'max']);

        $hint = $response->json();
        // Keur Massar → Plateau : ~18 km à vol d'oiseau × 1,3 → ~1 100 F.
        $this->assertSame(0, $hint['suggested'] % 100);
        $this->assertGreaterThanOrEqual($hint['min'], $hint['suggested']);
        $this->assertLessThanOrEqual($hint['max'], $hint['suggested']);
        $this->assertGreaterThanOrEqual(400, $hint['min']);
        $this->assertLessThanOrEqual(2000, $hint['max']);

        Http::assertNothingSent();
    }

    public function test_price_hint_clamps_short_trips_to_the_regulatory_floor(): void
    {
        $user = User::factory()->create();

        $hint = $this->getJson(
            '/api/trips/price-hint?origin=14.787,-17.315&destination=14.789,-17.316',
            $this->authed($user),
        )->assertOk()->json();

        $this->assertSame(400, $hint['min']);
        $this->assertSame(400, $hint['suggested']);
    }

    public function test_trip_endpoints_require_authentication(): void
    {
        $this->getJson('/api/trips/price-hint?origin=1,1&destination=2,2')
            ->assertUnauthorized();
        $this->postJson('/api/trips', [])->assertUnauthorized();
        $this->getJson('/api/trips/mine')->assertUnauthorized();
    }
}
