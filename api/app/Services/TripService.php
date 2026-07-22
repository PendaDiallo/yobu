<?php

namespace App\Services;

use App\Models\Trip;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class TripService
{
    public function __construct(private readonly RouteService $routes) {}

    /**
     * Crée le trajet récurrent : l'itinéraire et la durée viennent de la
     * Routes API, une seule fois, maintenant.
     *
     * @param  array<string, mixed>  $data  données validées de StoreTripRequest
     */
    public function create(User $driver, array $data): Trip
    {
        $route = $this->routes->fetchRoute(
            (float) $data['origin_lat'],
            (float) $data['origin_lng'],
            (float) $data['dest_lat'],
            (float) $data['dest_lng'],
        );

        $lineString = 'LINESTRING('.implode(',', array_map(
            fn (array $point) => sprintf('%.6F %.6F', $point[1], $point[0]),
            $route['points'],
        )).')';

        $trip = Trip::create([
            'driver_id' => $driver->id,
            'origin_label' => $data['origin_label'],
            'origin_point' => sprintf('POINT(%.6F %.6F)', $data['origin_lng'], $data['origin_lat']),
            'dest_label' => $data['dest_label'],
            'dest_point' => sprintf('POINT(%.6F %.6F)', $data['dest_lng'], $data['dest_lat']),
            'route' => $lineString,
            'departure_time' => $data['departure_time'],
            'duration_minutes' => $route['duration_minutes'],
            'days_of_week' => $data['days_of_week'],
            'seats_total' => $data['seats_total'],
            'price_per_seat' => $data['price_per_seat'],
        ]);

        return Trip::withCoordinates()->findOrFail($trip->id);
    }

    /**
     * La fourchette de prix — parade réglementaire (01-produit.md §3bis),
     * calculée SANS appel Google (02-technique.md §4bis) : vol d'oiseau
     * Postgres × 1,3, ~50 F/km, bornée [400, 2000].
     *
     * @return array{min: int, suggested: int, max: int}
     */
    public function priceHint(
        float $originLat,
        float $originLng,
        float $destLat,
        float $destLng,
    ): array {
        $straightMeters = (float) DB::selectOne(
            'SELECT ST_Distance(
                ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography,
                ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography
            ) AS straight_m',
            [$originLng, $originLat, $destLng, $destLat],
        )->straight_m;

        $roadKm = $straightMeters * 1.3 / 1000;

        $suggested = (int) round($roadKm * 50, -2);
        $suggested = max(400, min(2000, $suggested));

        return [
            'min' => (int) max(400, round($suggested * 0.7)),
            'suggested' => $suggested,
            'max' => (int) min(2000, round($suggested * 1.4)),
        ];
    }
}
