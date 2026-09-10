<?php

namespace Tests\Feature;

use App\Models\Booking;
use App\Models\Rating;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

class RatingTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Le guard `sanctum` met en cache le premier utilisateur résolu dans un
     * test (cf JOURNAL 18/07). Pour un scénario multi-acteurs, on vide le
     * guard avant chaque requête.
     *
     * @param  array<string, mixed>  $data
     */
    private function postAs(string $uri, array $data, User $as): TestResponse
    {
        $this->app['auth']->forgetGuards();

        return $this->postJson($uri, $data, [
            'Authorization' => 'Bearer '.$as->createToken('t')->plainTextToken,
        ]);
    }

    private function getAs(string $uri, User $as): TestResponse
    {
        $this->app['auth']->forgetGuards();

        return $this->getJson($uri, [
            'Authorization' => 'Bearer '.$as->createToken('t')->plainTextToken,
        ]);
    }

    private function completedBooking(): Booking
    {
        $trip = Trip::factory()->create();
        $rider = User::factory()->create();

        return Booking::factory()->completed()->for($trip)->for($rider, 'rider')->create();
    }

    public function test_rating_updates_the_recipients_average_and_count(): void
    {
        $booking = $this->completedBooking();
        $rider = $booking->rider;
        $driver = $booking->trip->driver;

        $this->postAs('/api/ratings', [
            'booking_id' => $booking->id,
            'score' => 4,
            'tags' => ['ponctuel', 'sympa'],
            'comment' => 'Trajet nickel',
        ], $rider)->assertCreated()
            ->assertJsonPath('data.to_user_id', $driver->id)
            ->assertJsonPath('data.score', 4);

        $driver->refresh();
        $this->assertSame('4.0', (string) $driver->rating);
        $this->assertSame(1, $driver->rating_count);

        // Une 2e note d'un autre passager fait la moyenne.
        $other = Booking::factory()->completed()->for($booking->trip)->create();
        $this->postAs('/api/ratings', ['booking_id' => $other->id, 'score' => 2], $other->rider)
            ->assertCreated();

        $driver->refresh();
        $this->assertSame('3.0', (string) $driver->rating);
        $this->assertSame(2, $driver->rating_count);
    }

    public function test_both_driver_and_rider_can_rate_the_same_booking(): void
    {
        $booking = $this->completedBooking();
        $rider = $booking->rider;
        $driver = $booking->trip->driver;

        $this->postAs('/api/ratings', ['booking_id' => $booking->id, 'score' => 5], $rider)
            ->assertCreated()
            ->assertJsonPath('data.to_user_id', $driver->id);

        $this->postAs('/api/ratings', ['booking_id' => $booking->id, 'score' => 3], $driver)
            ->assertCreated()
            ->assertJsonPath('data.to_user_id', $rider->id);

        $this->assertSame(2, Rating::where('booking_id', $booking->id)->count());

        $driver->refresh();
        $this->assertSame('5.0', (string) $driver->rating);
        $this->assertSame(1, $driver->rating_count);

        $rider->refresh();
        $this->assertSame('3.0', (string) $rider->rating);
        $this->assertSame(1, $rider->rating_count);
    }

    public function test_rating_twice_is_rejected_in_french(): void
    {
        $booking = $this->completedBooking();

        $this->postAs('/api/ratings', ['booking_id' => $booking->id, 'score' => 5], $booking->rider)
            ->assertCreated();

        $this->postAs('/api/ratings', ['booking_id' => $booking->id, 'score' => 1], $booking->rider)
            ->assertStatus(422)
            ->assertJsonPath('errors.booking_id.0', 'Tu as déjà noté ce trajet.');

        $this->assertSame(1, Rating::where('booking_id', $booking->id)->count());
    }

    public function test_a_stranger_cannot_rate_a_booking(): void
    {
        $booking = $this->completedBooking();

        $this->postAs('/api/ratings', ['booking_id' => $booking->id, 'score' => 1],
            User::factory()->create())->assertForbidden();
    }

    public function test_a_booking_that_is_not_completed_cannot_be_rated(): void
    {
        $trip = Trip::factory()->create();
        $rider = User::factory()->create();
        $booking = Booking::factory()->accepted()->for($trip)->for($rider, 'rider')->create();

        $this->postAs('/api/ratings', ['booking_id' => $booking->id, 'score' => 5], $rider)
            ->assertForbidden();
    }

    public function test_tags_outside_the_allowed_set_are_rejected(): void
    {
        $booking = $this->completedBooking();

        $this->postAs('/api/ratings', [
            'booking_id' => $booking->id,
            'score' => 5,
            'tags' => ['ponctuel', 'super_cool'],
        ], $booking->rider)->assertStatus(422);
    }

    public function test_rating_requires_authentication(): void
    {
        $this->postJson('/api/ratings', [])->assertUnauthorized();
    }

    public function test_bookings_index_exposes_can_rate(): void
    {
        $rider = User::factory()->create();
        $trip = Trip::factory()->create();
        $done = Booking::factory()->completed()->for($trip)->for($rider, 'rider')->create();
        $upcoming = Booking::factory()->accepted()->for($trip)->for($rider, 'rider')
            ->create(['date' => now('Africa/Dakar')->addWeek()->toDateString()]);

        $byId = collect($this->getAs('/api/bookings', $rider)->json('data'))->keyBy('id');
        $this->assertTrue($byId[$done->id]['can_rate']);
        $this->assertFalse($byId[$upcoming->id]['can_rate']);

        $this->postAs('/api/ratings', ['booking_id' => $done->id, 'score' => 5], $rider)
            ->assertCreated();

        $byId = collect($this->getAs('/api/bookings', $rider)->json('data'))->keyBy('id');
        $this->assertFalse($byId[$done->id]['can_rate']);
    }
}
