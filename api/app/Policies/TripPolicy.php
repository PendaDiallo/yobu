<?php

namespace App\Policies;

use App\Models\Trip;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class TripPolicy
{
    public function create(User $user): Response
    {
        return in_array($user->role, ['driver', 'both'], true)
            ? Response::allow()
            : Response::deny('Passe ton profil en conducteur pour publier un trajet.');
    }

    public function update(User $user, Trip $trip): bool
    {
        return $user->id === $trip->driver_id;
    }

    public function delete(User $user, Trip $trip): bool
    {
        return $user->id === $trip->driver_id;
    }
}
