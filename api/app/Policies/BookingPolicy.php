<?php

namespace App\Policies;

use App\Models\Booking;
use App\Models\User;

class BookingPolicy
{
    public function view(User $user, Booking $booking): bool
    {
        return $user->id === $booking->rider_id
            || $user->id === $booking->trip->driver_id;
    }

    /** Le conducteur SEUL accepte ou refuse. */
    public function respond(User $user, Booking $booking): bool
    {
        return $user->id === $booking->trip->driver_id;
    }

    /** Le passager seul annule sa demande. */
    public function cancel(User $user, Booking $booking): bool
    {
        return $user->id === $booking->rider_id;
    }

    /**
     * On ne note qu'un trajet terminé, et seulement si on y a participé
     * (docs/02-technique.md §6). L'unicité par personne est portée par la
     * contrainte `UNIQUE (booking_id, from_user_id)`, pas ici.
     */
    public function rate(User $user, Booking $booking): bool
    {
        if ($booking->status !== 'completed') {
            return false;
        }

        return $user->id === $booking->rider_id
            || $user->id === $booking->trip->driver_id;
    }
}
