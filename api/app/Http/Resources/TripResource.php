<?php

namespace App\Http\Resources;

use App\Models\Trip;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin Trip
 */
class TripResource extends JsonResource
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
            'origin_label' => $this->origin_label,
            'dest_label' => $this->dest_label,
            // Présents quand la requête a chargé withCoordinates().
            'origin' => $this->when($this->origin_lat !== null, fn () => [
                'lat' => (float) $this->origin_lat,
                'lng' => (float) $this->origin_lng,
            ]),
            'destination' => $this->when($this->dest_lat !== null, fn () => [
                'lat' => (float) $this->dest_lat,
                'lng' => (float) $this->dest_lng,
            ]),
            'departure_time' => substr($this->departure_time, 0, 5),
            'duration_minutes' => $this->duration_minutes,
            'days_of_week' => $this->days_of_week,
            'seats_total' => $this->seats_total,
            'price_per_seat' => $this->price_per_seat,
            'active' => $this->active,
        ];
    }
}
