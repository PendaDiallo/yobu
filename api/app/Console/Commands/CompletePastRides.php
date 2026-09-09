<?php

namespace App\Console\Commands;

use App\Models\Booking;
use Carbon\CarbonImmutable;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

/**
 * Clôture automatique (planifiée toutes les 30 min, cf routes/console.php).
 *
 * Une réservation acceptée passe en `completed` 2 h après l'heure de départ
 * du trajet ce jour-là. Le compteur `trips_completed` monte alors : +1 par
 * réservation pour le passager, +1 par couple (trajet, date) pour le
 * conducteur — il a fait UN trajet, quel que soit le nombre de passagers.
 */
class CompletePastRides extends Command
{
    protected $signature = 'app:complete-past-rides';

    protected $description = 'Passe en completed les réservations dont le trajet est fini depuis 2 h, et incrémente les compteurs.';

    public function handle(): int
    {
        $now = CarbonImmutable::now('Africa/Dakar');

        $due = Booking::query()
            ->where('status', 'accepted')
            ->where('date', '<=', $now->toDateString())
            ->with('rider', 'trip.driver')
            ->get()
            ->filter(function (Booking $booking) use ($now): bool {
                $departure = CarbonImmutable::parse(
                    $booking->date->toDateString().' '.$booking->trip->departure_time,
                    'Africa/Dakar',
                );

                return $now->greaterThanOrEqualTo($departure->addHours(2));
            });

        if ($due->isEmpty()) {
            $this->info('Rien à clôturer.');

            return self::SUCCESS;
        }

        DB::transaction(function () use ($due): void {
            foreach ($due as $booking) {
                $booking->update(['status' => 'completed']);
                $booking->rider->increment('trips_completed');
            }

            $due->groupBy(fn (Booking $b) => $b->trip_id.'|'.$b->date->toDateString())
                ->each(fn ($group) => $group->first()->trip->driver->increment('trips_completed'));
        });

        $this->info("Clôturées : {$due->count()} réservation(s).");

        return self::SUCCESS;
    }
}
