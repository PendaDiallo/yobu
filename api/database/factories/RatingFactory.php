<?php

namespace Database\Factories;

use App\Models\Booking;
use App\Models\Rating;
use App\Models\Trip;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Rating>
 */
class RatingFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        // Par défaut : le passager note le conducteur d'un trajet terminé.
        return [
            'booking_id' => Booking::factory()->completed(),
            'from_user_id' => fn (array $attributes) => Booking::find($attributes['booking_id'])->rider_id,
            'to_user_id' => function (array $attributes) {
                $booking = Booking::find($attributes['booking_id']);

                return Trip::find($booking->trip_id)->driver_id;
            },
            'score' => fake()->numberBetween(3, 5),
            'tags' => fake()->randomElements(Rating::TAGS, fake()->numberBetween(0, 2)),
            'comment' => null,
        ];
    }
}
