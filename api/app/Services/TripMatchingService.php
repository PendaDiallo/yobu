<?php

namespace App\Services;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * LE cœur technique de YOBU (docs/02-technique.md §4).
 *
 * Le SQL sort jusqu'à 50 candidats bruts triés par proximité — il ne trie
 * jamais par score : le score n'existe pas en base, il dépend d'une
 * normalisation du prix sur l'ensemble des résultats. Le scoring et le
 * top 10 se font ici, en PHP, sur ≤ 50 lignes.
 *
 * Jamais d'appel Routes API ici : la route est déjà en base.
 */
class TripMatchingService
{
    private const PICKUP_RADIUS_M = 1500;

    private const DROPOFF_RADIUS_M = 3000;

    private const LATE_TOLERANCE_MIN = 20;

    private const CANDIDATES = 50;

    private const TOP = 10;

    /**
     * @return list<object> les ≤ 10 meilleurs candidats, score ajouté,
     *                      triés par score décroissant
     */
    public function search(
        float $originLat,
        float $originLng,
        float $destLat,
        float $destLng,
        string $arrivalBefore,
        string $date,
    ): array {
        $rows = DB::select(<<<'SQL'
            SELECT
              t.*,
              ST_Distance(t.route, ST_SetSRID(ST_MakePoint(:o_lng1, :o_lat1), 4326)::geography)      AS pickup_distance_m,
              ST_Distance(t.dest_point, ST_SetSRID(ST_MakePoint(:d_lng1, :d_lat1), 4326)::geography) AS dropoff_distance_m,
              (t.departure_time + (t.duration_minutes || ' minutes')::interval)::time                AS estimated_arrival,
              u.first_name      AS driver_first_name,
              u.last_name       AS driver_last_name,
              u.photo_url       AS driver_photo_url,
              u.rating          AS driver_rating,
              u.rating_count    AS driver_rating_count,
              u.trips_completed AS driver_trips_completed,
              (SELECT COUNT(*) FROM bookings b
                 WHERE b.trip_id = t.id AND b.date = :date1 AND b.status = 'accepted') AS seats_taken
            FROM trips t
            JOIN users u ON u.id = t.driver_id
            WHERE t.active
              AND :dow = ANY(t.days_of_week)
              -- le passager est à moins de 1,5 km de l'itinéraire
              AND ST_DWithin(t.route, ST_SetSRID(ST_MakePoint(:o_lng2, :o_lat2), 4326)::geography, :pickup_radius)
              -- sa destination est à moins de 3 km de celle du trajet
              AND ST_DWithin(t.dest_point, ST_SetSRID(ST_MakePoint(:d_lng2, :d_lat2), 4326)::geography, :dropoff_radius)
              -- il arrive à l'heure (± 20 min de tolérance)
              AND (t.departure_time + (t.duration_minutes || ' minutes')::interval)
                  <= (:arrival::time + interval '20 minutes')
              -- il reste de la place ce jour-là
              AND (SELECT COUNT(*) FROM bookings b
                     WHERE b.trip_id = t.id AND b.date = :date2 AND b.status = 'accepted') < t.seats_total
            ORDER BY pickup_distance_m ASC
            LIMIT :candidates
            SQL, [
            'o_lat1' => $originLat, 'o_lng1' => $originLng,
            'd_lat1' => $destLat, 'd_lng1' => $destLng,
            'o_lat2' => $originLat, 'o_lng2' => $originLng,
            'd_lat2' => $destLat, 'd_lng2' => $destLng,
            'date1' => $date, 'date2' => $date,
            'dow' => CarbonImmutable::parse($date)->isoWeekday(),
            'arrival' => $arrivalBefore,
            'pickup_radius' => self::PICKUP_RADIUS_M,
            'dropoff_radius' => self::DROPOFF_RADIUS_M,
            'candidates' => self::CANDIDATES,
        ]);

        return $this->scoreAndRank($rows, $arrivalBefore);
    }

    /**
     * score = 0.4 × (1 − pickup/1500) + 0.3 × (1 − |Δmin|/20)
     *       + 0.2 × (rating/5) + 0.1 × prix normalisé inversé.
     * Les poids somment à 1,0.
     *
     * @param  list<object>  $rows
     * @return list<object>
     */
    private function scoreAndRank(array $rows, string $arrivalBefore): array
    {
        if ($rows === []) {
            return [];
        }

        $prices = array_map(fn (object $row) => (int) $row->price_per_seat, $rows);
        $minPrice = min($prices);
        $maxPrice = max($prices);
        $wantedMinutes = $this->minutes($arrivalBefore);

        foreach ($rows as $row) {
            $deltaMinutes = abs($wantedMinutes - $this->minutes($row->estimated_arrival));
            $priceNormalized = $maxPrice === $minPrice
                ? 1.0
                : 1 - (($row->price_per_seat - $minPrice) / ($maxPrice - $minPrice));

            $row->score = round(
                0.4 * (1 - $row->pickup_distance_m / self::PICKUP_RADIUS_M)
                + 0.3 * (1 - $deltaMinutes / self::LATE_TOLERANCE_MIN)
                + 0.2 * ((float) $row->driver_rating / 5)
                + 0.1 * $priceNormalized,
                4,
            );
        }

        usort($rows, fn (object $a, object $b) => $b->score <=> $a->score);

        return array_slice($rows, 0, self::TOP);
    }

    private function minutes(string $time): int
    {
        [$hours, $minutes] = explode(':', $time);

        return (int) $hours * 60 + (int) $minutes;
    }
}
