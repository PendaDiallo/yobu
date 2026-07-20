<?php

namespace Database\Factories;

use App\Models\Trip;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<\App\Models\Booking>
 */
class BookingFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'trip_id' => Trip::factory(),
            'rider_id' => User::factory(),
            // Le prochain jour ouvré : les trajets du corridor roulent lun-ven.
            'date' => fake()->dateTimeBetween('next weekday', '+7 weekdays')
                ->format('Y-m-d'),
            'status' => 'pending',
            'seats' => 1,
            'price_paid' => fn (array $attributes) => Trip::find($attributes['trip_id'])->price_per_seat,
        ];
    }

    public function accepted(): static
    {
        return $this->state(['status' => 'accepted']);
    }

    public function completed(): static
    {
        return $this->state([
            'status' => 'completed',
            'date' => fake()->dateTimeBetween('-7 weekdays', 'yesterday')
                ->format('Y-m-d'),
        ]);
    }
}
