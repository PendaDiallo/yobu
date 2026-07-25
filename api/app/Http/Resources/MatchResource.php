<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Un candidat du matching : la ligne SQL brute de TripMatchingService,
 * score ajouté. Tout ce que search_results affichera arrive déjà calculé —
 * l'app ne calcule rien.
 *
 * @property object $resource
 */
class MatchResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'trip' => [
                'id' => $this->resource->id,
                'origin_label' => $this->resource->origin_label,
                'dest_label' => $this->resource->dest_label,
                'departure_time' => substr($this->resource->departure_time, 0, 5),
                'arrival_time' => substr($this->resource->estimated_arrival, 0, 5),
                'duration_minutes' => $this->resource->duration_minutes,
                'price_per_seat' => $this->resource->price_per_seat,
                'seats_left' => $this->resource->seats_total - $this->resource->seats_taken,
            ],
            'driver' => [
                'id' => $this->resource->driver_id,
                'first_name' => $this->resource->driver_first_name,
                'last_name' => $this->resource->driver_last_name,
                'photo_url' => $this->resource->driver_photo_url,
                'rating' => (float) $this->resource->driver_rating,
                'rating_count' => $this->resource->driver_rating_count,
                'trips_completed' => $this->resource->driver_trips_completed,
                // Dérivés, comme dans UserResource (docs/02-technique.md §4ter).
                'badges' => array_values(array_filter([
                    'phone_verified',
                    $this->resource->driver_trips_completed >= 10 ? 'regular' : null,
                ])),
            ],
            'pickup_distance_m' => (int) round($this->resource->pickup_distance_m),
            'dropoff_distance_m' => (int) round($this->resource->dropoff_distance_m),
            'score' => $this->resource->score,
        ];
    }
}
