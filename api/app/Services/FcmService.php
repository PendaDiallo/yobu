<?php

namespace App\Services;

use App\Jobs\SendPushNotification;
use App\Models\Booking;

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
}
