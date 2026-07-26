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
}
