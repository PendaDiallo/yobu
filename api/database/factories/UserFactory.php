<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<User>
 */
class UserFactory extends Factory
{
    private const FIRST_NAMES = [
        'Awa', 'Moussa', 'Fatou', 'Ibrahima', 'Aminata', 'Ousmane',
        'Mariama', 'Cheikh', 'Astou', 'Mamadou', 'Ndeye', 'Abdoulaye',
    ];

    private const LAST_NAMES = [
        'Ndiaye', 'Diop', 'Sarr', 'Fall', 'Sow', 'Ba', 'Gueye', 'Faye',
        'Diallo', 'Cissé', 'Mbaye', 'Sy',
    ];

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'firebase_uid' => (string) Str::uuid(),
            'phone' => '+2217'.fake()->randomElement(['0', '5', '6', '7', '8'])
                .fake()->unique()->numerify('#######'),
            'first_name' => fake()->randomElement(self::FIRST_NAMES),
            'last_name' => fake()->randomElement(self::LAST_NAMES),
            'photo_url' => null,
            'role' => 'rider',
        ];
    }

    public function driver(): static
    {
        return $this->state(['role' => 'driver']);
    }
}
