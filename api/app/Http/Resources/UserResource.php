<?php

namespace App\Http\Resources;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin User
 */
class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'phone' => $this->phone,
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'photo_url' => $this->photo_url,
            'role' => $this->role,
            'rating' => (float) $this->rating,
            'rating_count' => $this->rating_count,
            'trips_completed' => $this->trips_completed,
            // Dérivés, jamais stockés (docs/02-technique.md §4ter).
            'badges' => array_values(array_filter([
                'phone_verified', // toujours vrai : l'auth EST un OTP
                $this->trips_completed >= 10 ? 'regular' : null,
            ])),
        ];
    }
}
