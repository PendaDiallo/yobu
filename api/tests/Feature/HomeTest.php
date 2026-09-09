<?php

namespace Tests\Feature;

use App\Models\Booking;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Tests\TestCase;

class HomeTest extends TestCase
{
    use RefreshDatabase;

    private function authed(User $user): array
    {
        return ['Authorization' => 'Bearer '.$user->createToken('t')->plainTextToken];
    }

    private function nextWeekday(int $offsetWeeks = 0): string
    {
        $day = Carbon::now('Africa/Dakar')->addWeeks($offsetWeeks);
        while ($day->isWeekend()) {
            $day = $day->addDay();
        }

        return $day->toDateString();
    }

    public function test_home_requires_authentication(): void
    {
        $this->getJson('/api/home')->assertUnauthorized();
    }

    public function test_a_rider_with_no_ride_gets_null(): void
    {
        $user = User::factory()->create();

        $this->getJson('/api/home', $this->authed($user))
            ->assertOk()
            ->assertExactJson(['next' => null]);
    }

    public function test_it_returns_the_riders_next_accepted_booking(): void
    {
        $rider = User::factory()->create();
        $trip = Trip::factory()->create(['departure_time' => '06:45']);

        Booking::factory()->for($trip)->for($rider, 'rider')->create([
            'status' => 'accepted',
            'date' => $this->nextWeekday(2),
        ]);
        $soon = Booking::factory()->for($trip)->for($rider, 'rider')->create([
            'status' => 'accepted',
            'date' => $this->nextWeekday(),
        ]);

        $this->getJson('/api/home', $this->authed($rider))
            ->assertOk()
            ->assertJsonPath('next.role', 'rider')
            ->assertJsonPath('next.date', $soon->date->toDateString())
            ->assertJsonPath('next.departure_time', '06:45')
            ->assertJsonPath('next.with.first_name', $trip->driver->first_name)
            // Le téléphone du conducteur : la réservation est acceptée.
            ->assertJsonPath('next.with.phone', $trip->driver->phone);
    }

    public function test_a_driver_sees_the_next_occurrence_of_their_trip_with_seats_taken(): void
    {
        $driver = User::factory()->driver()->create();
        $trip = Trip::factory()->for($driver, 'driver')->create([
            'days_of_week' => [1, 2, 3, 4, 5],
            'seats_total' => 4,
        ]);

        Booking::factory()->for($trip)->create([
            'status' => 'accepted',
            'date' => $this->nextWeekday(),
        ]);

        $response = $this->getJson('/api/home', $this->authed($driver))->assertOk();

        $response->assertJsonPath('next.role', 'driver')
            ->assertJsonPath('next.date', $this->nextWeekday())
            ->assertJsonPath('next.seats_taken', 1)
            ->assertJsonPath('next.seats_total', 4);
    }

    public function test_the_soonest_of_the_two_roles_wins(): void
    {
        $user = User::factory()->create(['role' => 'both']);

        // En tant que conducteur : prochaine occurrence dès le prochain jour ouvré.
        $ownTrip = Trip::factory()->for($user, 'driver')->create([
            'days_of_week' => [1, 2, 3, 4, 5],
        ]);

        // En tant que passager : accepté, mais dans 2 semaines.
        $otherTrip = Trip::factory()->create();
        Booking::factory()->for($otherTrip)->for($user, 'rider')->create([
            'status' => 'accepted',
            'date' => $this->nextWeekday(2),
        ]);

        $this->getJson('/api/home', $this->authed($user))
            ->assertOk()
            ->assertJsonPath('next.role', 'driver');
    }
}
