<?php

namespace App\Services;

use App\Jobs\SendPushNotification;
use App\Models\Booking;
use App\Models\Trip;

class FcmService
{
    /** Conducteur : quelqu'un a demandé une place. */
    public function notifyBookingRequested(Booking $booking): void
    {
        $booking->loadMissing('rider', 'trip.driver');

        $driver = $booking->trip->driver;
        $rider  = $booking->rider;

        SendPushNotification::dispatch(
            $driver,
            'Nouvelle demande',
            "{$rider->first_name} demande une place le {$booking->date->format('d/m/Y')}.",
            [
                'type'       => 'booking_requested',
                'booking_id' => (string) $booking->id,
            ],
        );
    }

    /** Passager : sa demande a été acceptée ou refusée. */
    public function notifyBookingResponded(Booking $booking): void
    {
        $booking->loadMissing('rider', 'trip.driver');

        $driver = $booking->trip->driver;
        $rider  = $booking->rider;

        if ($booking->status === 'accepted') {
            $title = 'Demande acceptée !';
            $body  = "{$driver->first_name} a accepté ta place le {$booking->date->format('d/m/Y')}.";
            $type  = 'booking_accepted';
        } else {
            $title = 'Demande refusée';
            $body  = "{$driver->first_name} n'a pas pu t'accepter ce jour-là.";
            $type  = 'booking_rejected';
        }

        SendPushNotification::dispatch(
            $rider,
            $title,
            $body,
            [
                'type'       => $type,
                'booking_id' => (string) $booking->id,
            ],
        );
    }

    /** Passager : rappel le matin même, le jour du trajet. */
    public function notifyMorningRider(Booking $booking): void
    {
        $booking->loadMissing('rider', 'trip.driver');
        $trip = $booking->trip;

        SendPushNotification::dispatch(
            $booking->rider,
            'Ton trajet ce matin',
            sprintf(
                '%s → %s, départ %s. Retrouve %s.',
                $trip->origin_label,
                $trip->dest_label,
                substr($trip->departure_time, 0, 5),
                $trip->driver->first_name,
            ),
            ['type' => 'morning_reminder'],
        );
    }

    /** Conducteur : rappel le matin même, avec le nombre de passagers. */
    public function notifyMorningDriver(Trip $trip, int $passengers): void
    {
        $trip->loadMissing('driver');

        SendPushNotification::dispatch(
            $trip->driver,
            'Tes passagers ce matin',
            sprintf(
                '%d passager%s sur %s → %s, départ %s.',
                $passengers,
                $passengers > 1 ? 's' : '',
                $trip->origin_label,
                $trip->dest_label,
                substr($trip->departure_time, 0, 5),
            ),
            ['type' => 'morning_reminder'],
        );
    }
}
