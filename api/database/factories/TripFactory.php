<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * Corridor de lancement : Keur Massar → Plateau. Vraies coordonnées de la
 * zone (CLAUDE.md) — pas de géographie inventée.
 *
 * @extends Factory<\App\Models\Trip>
 */
class TripFactory extends Factory
{
    /** Keur Massar (lat, lng) — les départs sont dispersés autour. */
    private const KEUR_MASSAR = [14.787, -17.315];

    /** Plateau (lat, lng). */
    private const PLATEAU = [14.669, -17.437];

    private const ORIGIN_LABELS = [
        'Keur Massar, Unité 15', 'Keur Massar, Boune', 'Keur Massar, Aïnoumady',
        'Keur Massar, Cité Sotrac', 'Keur Massar, Darou Missette',
    ];

    private const DEST_LABELS = [
        'Plateau, Place de l\'Indépendance', 'Plateau, Sandaga',
        'Plateau, Avenue Léopold Sédar Senghor', 'Plateau, Ponty',
    ];

    /**
     * L'itinéraire type du corridor : Keur Massar → autoroute → Plateau,
     * par Pikine, Patte d'Oie et Hann. lng lat, ordre WKT.
     */
    private const ROUTE_WKT = 'LINESTRING('
        .'-17.315 14.787, -17.330 14.772, -17.360 14.760, -17.390 14.745, '
        .'-17.408 14.722, -17.420 14.700, -17.433 14.680, -17.437 14.669)';

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        [$originLat, $originLng] = self::KEUR_MASSAR;
        [$destLat, $destLng] = self::PLATEAU;

        // ±~800 m autour du quartier : c'est la dispersion naturelle que le
        // matching doit absorber.
        $originLat += fake()->randomFloat(4, -0.008, 0.008);
        $originLng += fake()->randomFloat(4, -0.008, 0.008);
        $destLat += fake()->randomFloat(4, -0.004, 0.004);
        $destLng += fake()->randomFloat(4, -0.004, 0.004);

        $hour = fake()->numberBetween(5, 8);
        $minute = fake()->randomElement([0, 15, 30, 45]);

        return [
            'driver_id' => User::factory()->driver(),
            'origin_label' => fake()->randomElement(self::ORIGIN_LABELS),
            'origin_point' => sprintf('POINT(%.4F %.4F)', $originLng, $originLat),
            'dest_label' => fake()->randomElement(self::DEST_LABELS),
            'dest_point' => sprintf('POINT(%.4F %.4F)', $destLng, $destLat),
            'route' => self::ROUTE_WKT,
            'departure_time' => sprintf('%02d:%02d', $hour, $minute),
            'duration_minutes' => fake()->numberBetween(50, 80),
            'days_of_week' => [1, 2, 3, 4, 5],
            'seats_total' => fake()->numberBetween(2, 4),
            'price_per_seat' => fake()->numberBetween(5, 15) * 100,
            'active' => true,
        ];
    }

    public function inactive(): static
    {
        return $this->state(['active' => false]);
    }
}
