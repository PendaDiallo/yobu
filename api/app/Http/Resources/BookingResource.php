<?php

namespace App\Http\Resources;

use App\Models\Booking;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin Booking
 */
class BookingResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * Le téléphone de l'autre partie n'apparaît QU'UNE FOIS la réservation
     * acceptée — c'est lui qui alimente le bouton WhatsApp, et il ne se
     * montre pas avant (docs/01-produit.md §3).
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'date' => $this->date->format('Y-m-d'),
            'status' => $this->status,
            'seats' => $this->seats,
            'price_paid' => $this->price_paid,
            'trip' => [
                'id' => $this->trip->id,
                'origin_label' => $this->trip->origin_label,
                'dest_label' => $this->trip->dest_label,
                'departure_time' => substr($this->trip->departure_time, 0, 5),
                'duration_minutes' => $this->trip->duration_minutes,
            ],
            'driver' => $this->party($this->trip->driver),
            'rider' => $this->whenLoaded('rider', fn () => $this->party($this->rider)),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function party(User $user): array
    {
        return [
            'id' => $user->id,
            'first_name' => $user->first_name,
            'last_name' => $user->last_name,
            'photo_url' => $user->photo_url,
            'rating' => (float) $user->rating,
            'rating_count' => $user->rating_count,
            'trips_completed' => $user->trips_completed,
            'phone' => $this->when($this->status === 'accepted', $user->phone),
        ];
    }
}
