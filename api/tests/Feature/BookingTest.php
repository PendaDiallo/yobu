<?php

namespace Tests\Feature;

use App\Models\Booking;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BookingTest extends TestCase
{
    use RefreshDatabase;

    private function authed(User $user): array
    {
        return ['Authorization' => 'Bearer '.$user->createToken('t')->plainTextToken];
    }

    private function nextMonday(): string
    {
        return now()->next('Monday')->toDateString();
    }

    public function test_a_rider_can_request_a_seat(): void
    {
        $trip = Trip::factory()->create(['price_per_seat' => 1200]);
        $rider = User::factory()->create();

        $response = $this->postJson('/api/bookings', [
            'trip_id' => $trip->id,
            'date' => $this->nextMonday(),
        ], $this->authed($rider));

        $response->assertCreated()
            ->assertJsonPath('data.status', 'pending')
            ->assertJsonPath('data.price_paid', 1200)
            ->assertJsonPath('data.driver.first_name', $trip->driver->first_name);

        // Le téléphone du conducteur reste caché tant que ce n'est pas accepté.
        $this->assertArrayNotHasKey('phone', $response->json('data.driver'));
    }

    public function test_requesting_twice_the_same_day_is_rejected_in_french(): void
    {
        $booking = Booking::factory()->create(['date' => $this->nextMonday()]);

        $this->postJson('/api/bookings', [
            'trip_id' => $booking->trip_id,
            'date' => $this->nextMonday(),
        ], $this->authed($booking->rider))
            ->assertUnprocessable()
            ->assertJsonPath('errors.date.0', 'Tu as déjà demandé une place pour ce jour-là.');
    }

    public function test_a_driver_cannot_book_their_own_trip(): void
    {
        $trip = Trip::factory()->create();

        $this->postJson('/api/bookings', [
            'trip_id' => $trip->id,
            'date' => $this->nextMonday(),
        ], $this->authed($trip->driver))->assertUnprocessable();
    }

    public function test_booking_a_day_the_trip_does_not_run_is_rejected(): void
    {
        $trip = Trip::factory()->create(['days_of_week' => [1, 2, 3, 4, 5]]);

        $this->postJson('/api/bookings', [
            'trip_id' => $trip->id,
            'date' => now()->next('Sunday')->toDateString(),
        ], $this->authed(User::factory()->create()))
            ->assertUnprocessable()
            ->assertJsonPath('errors.date.0', 'Ce trajet ne roule pas ce jour-là.');
    }

    public function test_the_driver_can_accept_a_request_and_the_phone_appears(): void
    {
        $booking = Booking::factory()->create(['date' => $this->nextMonday()]);

        $response = $this->patchJson(
            "/api/bookings/{$booking->id}",
            ['status' => 'accepted'],
            $this->authed($booking->trip->driver),
        );

        $response->assertOk()
            ->assertJsonPath('data.status', 'accepted');
        $this->assertSame(
            $booking->rider->phone,
            $response->json('data.rider.phone'),
        );
    }

    public function test_accepting_when_the_last_seat_is_gone_returns_409(): void
    {
        $trip = Trip::factory()->create(['seats_total' => 1]);
        Booking::factory()->accepted()->create([
            'trip_id' => $trip->id,
            'date' => $this->nextMonday(),
        ]);
        $late = Booking::factory()->create([
            'trip_id' => $trip->id,
            'date' => $this->nextMonday(),
        ]);

        $this->patchJson(
            "/api/bookings/{$late->id}",
            ['status' => 'accepted'],
            $this->authed($trip->driver),
        )
            ->assertStatus(409)
            ->assertJsonPath('message', 'Ce trajet est déjà complet pour ce jour-là.');

        $this->assertSame('pending', $late->fresh()->status);
    }

    public function test_seats_total_is_never_decremented_by_acceptance(): void
    {
        $booking = Booking::factory()->create(['date' => $this->nextMonday()]);
        $seatsBefore = $booking->trip->seats_total;

        $this->patchJson("/api/bookings/{$booking->id}", ['status' => 'accepted'],
            $this->authed($booking->trip->driver))->assertOk();

        $this->assertSame($seatsBefore, $booking->trip->fresh()->seats_total);
    }

    public function test_only_the_driver_can_respond(): void
    {
        $booking = Booking::factory()->create();

        // Le passager lui-même ne peut pas s'auto-accepter.
        $this->patchJson("/api/bookings/{$booking->id}", ['status' => 'accepted'],
            $this->authed($booking->rider))->assertForbidden();
    }

    public function test_a_stranger_cannot_respond(): void
    {
        $booking = Booking::factory()->create();

        $this->patchJson("/api/bookings/{$booking->id}", ['status' => 'rejected'],
            $this->authed(User::factory()->create()))->assertForbidden();
    }

    public function test_the_rider_can_cancel_their_own_request(): void
    {
        $booking = Booking::factory()->create();

        $this->patchJson("/api/bookings/{$booking->id}", ['status' => 'cancelled'],
            $this->authed($booking->rider))
            ->assertOk()
            ->assertJsonPath('data.status', 'cancelled');
    }

    public function test_an_already_handled_request_cannot_be_accepted_again(): void
    {
        $booking = Booking::factory()->create(['status' => 'rejected']);

        $this->patchJson("/api/bookings/{$booking->id}", ['status' => 'accepted'],
            $this->authed($booking->trip->driver))
            ->assertUnprocessable()
            ->assertJsonPath('errors.status.0', 'Cette demande a déjà été traitée.');
    }

    public function test_index_returns_my_bookings_with_the_trip(): void
    {
        $booking = Booking::factory()->create();
        Booking::factory()->count(2)->create(); // d'autres passagers

        $this->getJson('/api/bookings', $this->authed($booking->rider))
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.trip.id', $booking->trip_id);
    }

    public function test_received_returns_requests_on_my_trips_pending_first(): void
    {
        $trip = Trip::factory()->create();
        $accepted = Booking::factory()->accepted()
            ->create(['trip_id' => $trip->id]);
        $pending = Booking::factory()->create(['trip_id' => $trip->id]);

        $response = $this->getJson('/api/bookings/received',
            $this->authed($trip->driver));

        $response->assertOk()->assertJsonCount(2, 'data')
            ->assertJsonPath('data.0.id', $pending->id)
            ->assertJsonPath('data.1.id', $accepted->id);
    }

    public function test_booking_endpoints_require_authentication(): void
    {
        $this->postJson('/api/bookings', [])->assertUnauthorized();
        $this->getJson('/api/bookings')->assertUnauthorized();
        $this->getJson('/api/bookings/received')->assertUnauthorized();
    }
}
