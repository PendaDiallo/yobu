<?php

namespace App\Console\Commands;

use App\Models\Booking;
use App\Services\FcmService;
use Carbon\CarbonImmutable;
use Illuminate\Console\Command;

/**
 * Le rappel du matin (planifié à 5h30 Africa/Dakar, cf routes/console.php).
 *
 * On ne réveille que les gens concernés aujourd'hui : un passager par
 * réservation acceptée du jour, un conducteur par trajet ayant au moins un
 * passager accepté aujourd'hui.
 */
class SendDailyReminders extends Command
{
    protected $signature = 'app:daily-reminders';

    protected $description = 'Rappel du matin aux passagers et conducteurs qui ont un trajet aujourd\'hui.';

    public function handle(FcmService $fcm): int
    {
        $today = CarbonImmutable::now('Africa/Dakar')->toDateString();

        $bookings = Booking::query()
            ->where('status', 'accepted')
            ->where('date', $today)
            ->with('rider', 'trip.driver')
            ->get();

        foreach ($bookings as $booking) {
            $fcm->notifyMorningRider($booking);
        }

        $byTrip = $bookings->groupBy('trip_id');
        $byTrip->each(
            fn ($group) => $fcm->notifyMorningDriver($group->first()->trip, $group->count()),
        );

        $this->info("Rappels : {$bookings->count()} passager(s), {$byTrip->count()} conducteur(s).");

        return self::SUCCESS;
    }
}
