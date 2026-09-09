<?php

namespace App\Services;

use App\Models\Booking;
use App\Models\Trip;
use App\Models\User;
use Carbon\CarbonImmutable;

/**
 * Le « prochain trajet » du dashboard. Calculé côté serveur : l'app affiche
 * ce bloc tel quel, elle ne compare aucune date ni ne devine aucun rôle.
 *
 * « Prochain » = le plus tôt entre la prochaine réservation acceptée du
 * passager et la prochaine occurrence d'un trajet actif du conducteur.
 */
class HomeService
{
    /** @return array<string, mixed>|null */
    public function nextRide(User $user): ?array
    {
        $candidates = array_values(array_filter([
            $this->asRider($user),
            $this->asDriver($user),
        ]));

        if ($candidates === []) {
            return null;
        }

        usort(
            $candidates,
            fn (array $a, array $b) => [$a['date'], $a['departure_time']] <=> [$b['date'], $b['departure_time']],
        );

        return $candidates[0];
    }

    /** @return array<string, mixed>|null */
    private function asRider(User $user): ?array
    {
        $booking = Booking::query()
            ->where('rider_id', $user->id)
            ->where('status', 'accepted')
            ->where('date', '>=', CarbonImmutable::now('Africa/Dakar')->toDateString())
            ->orderBy('date')
            ->with('trip.driver')
            ->first();

        if ($booking === null) {
            return null;
        }

        $trip = $booking->trip;

        return [
            'role' => 'rider',
            'date' => $booking->date->toDateString(),
            'departure_time' => substr($trip->departure_time, 0, 5),
            'origin_label' => $trip->origin_label,
            'dest_label' => $trip->dest_label,
            'price' => $booking->price_paid,
            'with' => [
                'first_name' => $trip->driver->first_name,
                'last_name' => $trip->driver->last_name,
                'photo_url' => $trip->driver->photo_url,
                'phone' => $trip->driver->phone,
            ],
        ];
    }

    /** @return array<string, mixed>|null */
    private function asDriver(User $user): ?array
    {
        $best = null;

        foreach (Trip::where('driver_id', $user->id)->where('active', true)->get() as $trip) {
            $date = $this->nextOccurrence($trip->days_of_week);
            if ($date === null || ($best !== null && $date >= $best['date'])) {
                continue;
            }

            $best = [
                'role' => 'driver',
                'date' => $date,
                'departure_time' => substr($trip->departure_time, 0, 5),
                'origin_label' => $trip->origin_label,
                'dest_label' => $trip->dest_label,
                'seats_taken' => Booking::where('trip_id', $trip->id)
                    ->where('date', $date)
                    ->where('status', 'accepted')
                    ->count(),
                'seats_total' => $trip->seats_total,
            ];
        }

        return $best;
    }

    /**
     * La prochaine date (aujourd'hui inclus) qui tombe un jour où le trajet
     * roule. `days_of_week` est en ISO, lundi = 1.
     *
     * @param  list<int>  $daysOfWeek
     */
    private function nextOccurrence(array $daysOfWeek): ?string
    {
        if ($daysOfWeek === []) {
            return null;
        }

        $day = CarbonImmutable::now('Africa/Dakar')->startOfDay();

        for ($i = 0; $i < 7; $i++, $day = $day->addDay()) {
            if (in_array($day->isoWeekday(), $daysOfWeek, true)) {
                return $day->toDateString();
            }
        }

        return null;
    }
}
