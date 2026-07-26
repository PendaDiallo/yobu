<?php

namespace App\Services;

use App\Exceptions\TripFullException;
use App\Models\Booking;
use App\Models\Trip;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class BookingService
{
    /**
     * La demande du passager : pending, prix figé au moment de la demande.
     */
    public function request(User $rider, Trip $trip, string $date): Booking
    {
        if (! $trip->active) {
            throw ValidationException::withMessages([
                'trip_id' => 'Ce trajet n\'est plus actif.',
            ]);
        }

        if ($trip->driver_id === $rider->id) {
            throw ValidationException::withMessages([
                'trip_id' => 'Tu ne peux pas réserver ton propre trajet.',
            ]);
        }

        $dayOfWeek = CarbonImmutable::parse($date)->isoWeekday();
        if (! in_array($dayOfWeek, $trip->days_of_week, true)) {
            throw ValidationException::withMessages([
                'date' => 'Ce trajet ne roule pas ce jour-là.',
            ]);
        }

        $alreadyRequested = Booking::where('trip_id', $trip->id)
            ->where('rider_id', $rider->id)
            ->where('date', $date)
            ->exists();
        if ($alreadyRequested) {
            throw ValidationException::withMessages([
                'date' => 'Tu as déjà demandé une place pour ce jour-là.',
            ]);
        }

        return Booking::create([
            'trip_id' => $trip->id,
            'rider_id' => $rider->id,
            'date' => $date,
            'status' => 'pending',
            'seats' => 1,
            'price_paid' => $trip->price_per_seat,
        ]);
    }

    /**
     * L'acceptation — docs/02-technique.md §5, au pseudo-code près :
     * transaction + lockForUpdate + comptage des accepted pour
     * (trip_id, date). seats_total ne se décrémente JAMAIS.
     *
     * @throws TripFullException
     */
    public function accept(Booking $booking): Booking
    {
        DB::transaction(function () use ($booking) {
            $trip = Trip::where('id', $booking->trip_id)->lockForUpdate()->first();

            $taken = Booking::where('trip_id', $trip->id)
                ->where('date', $booking->date)
                ->where('status', 'accepted')
                ->count();

            if ($taken >= $trip->seats_total) {
                throw new TripFullException();
            }

            $booking->update(['status' => 'accepted']);
        });

        return $booking;
    }
}
