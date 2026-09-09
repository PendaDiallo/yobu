<?php

namespace Tests\Feature;

use App\Models\Booking;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Tests\TestCase;

class CompletePastRidesTest extends TestCase
{
    use RefreshDatabase;

    public function test_an_accepted_ride_two_hours_past_departure_is_completed(): void
    {
        $trip = Trip::factory()->create(['departure_time' => '06:45']);
        $rider = User::factory()->create();

        $booking = Booking::factory()->for($trip)->for($rider, 'rider')->create([
            'status' => 'accepted',
            'date' => Carbon::yesterday('Africa/Dakar')->toDateString(),
        ]);

        $this->artisan('app:complete-past-rides')->assertSuccessful();

        $this->assertSame('completed', $booking->fresh()->status);
        $this->assertSame(1, $rider->fresh()->trips_completed);
        $this->assertSame(1, $trip->driver->fresh()->trips_completed);
    }

    public function test_a_ride_still_within_the_two_hour_window_is_left_alone(): void
    {
        // Départ dans le futur proche aujourd'hui → clairement pas fini.
        $soon = Carbon::now('Africa/Dakar')->addHour();
        $trip = Trip::factory()->create(['departure_time' => $soon->format('H:i')]);

        $booking = Booking::factory()->for($trip)->create([
            'status' => 'accepted',
            'date' => Carbon::now('Africa/Dakar')->toDateString(),
        ]);

        $this->artisan('app:complete-past-rides')->assertSuccessful();

        $this->assertSame('accepted', $booking->fresh()->status);
    }

    public function test_driver_counts_one_trip_regardless_of_passenger_count(): void
    {
        $trip = Trip::factory()->create([
            'departure_time' => '06:45',
            'seats_total' => 4,
        ]);
        $date = Carbon::yesterday('Africa/Dakar')->toDateString();

        Booking::factory()->count(3)->for($trip)->sequence(
            ['rider_id' => User::factory()],
            ['rider_id' => User::factory()],
            ['rider_id' => User::factory()],
        )->create(['status' => 'accepted', 'date' => $date]);

        $this->artisan('app:complete-past-rides')->assertSuccessful();

        // 3 trajets pour les passagers (1 chacun), 1 seul pour le conducteur.
        $this->assertSame(1, $trip->driver->fresh()->trips_completed);
        $this->assertSame(
            3,
            Booking::where('trip_id', $trip->id)->where('status', 'completed')->count(),
        );
    }

    public function test_pending_and_already_completed_rides_are_untouched(): void
    {
        $trip = Trip::factory()->create(['departure_time' => '06:45']);
        $date = Carbon::yesterday('Africa/Dakar')->toDateString();

        $pending = Booking::factory()->for($trip)->create(['status' => 'pending', 'date' => $date]);
        $done = Booking::factory()->for($trip)->create(['status' => 'completed', 'date' => $date]);

        $this->artisan('app:complete-past-rides')->assertSuccessful();

        $this->assertSame('pending', $pending->fresh()->status);
        $this->assertSame(0, $trip->driver->fresh()->trips_completed);
        $this->assertSame(0, $done->rider->fresh()->trips_completed);
    }
}
