<?php

namespace Database\Seeders;

use App\Models\Booking;
use App\Models\Rating;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

/**
 * Un matin plausible sur le corridor Keur Massar → Plateau : des conducteurs
 * qui publient, des passagers qui demandent, quelques trajets déjà faits
 * et notés.
 */
class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 6 conducteurs, chacun son trajet récurrent du matin.
        $trips = Trip::factory()
            ->count(6)
            ->create();

        $riders = User::factory()->count(10)->create();

        // Des demandes en attente et des places acceptées sur les prochains jours.
        foreach ($riders as $index => $rider) {
            $trip = $trips[$index % $trips->count()];

            Booking::factory()
                ->for($trip)
                ->for($rider, 'rider')
                ->state($index % 3 === 0 ? [] : ['status' => 'accepted'])
                ->create();
        }

        // Des trajets déjà faits, notés par le passager.
        Rating::factory()
            ->count(8)
            ->create();

        // Un conducteur stable pour les tests manuels (Postman, app).
        $moussa = User::factory()->driver()->create([
            'first_name' => 'Moussa',
            'last_name' => 'Diop',
            'phone' => '+221770000001',
            'trips_completed' => 24,
        ]);
        Trip::factory()->for($moussa, 'driver')->create([
            'origin_label' => 'Keur Massar, Unité 15',
            'dest_label' => 'Plateau, Place de l\'Indépendance',
            'departure_time' => '06:45',
            'price_per_seat' => 1000,
            'seats_total' => 3,
        ]);
    }
}
