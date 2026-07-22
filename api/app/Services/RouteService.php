<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * L'itinéraire d'un trajet, via la Routes API (pas Directions — legacy).
 * Appelée UNE SEULE FOIS, à la création du trajet. Jamais à la recherche.
 */
class RouteService
{
    private const ENDPOINT = 'https://routes.googleapis.com/directions/v2:computeRoutes';

    /**
     * @return array{points: list<array{float, float}>, duration_minutes: int}
     *         points : liste de [lat, lng]
     */
    public function fetchRoute(
        float $originLat,
        float $originLng,
        float $destLat,
        float $destLng,
    ): array {
        $key = config('services.google_maps.key');

        if (! $key) {
            return $this->approximate($originLat, $originLng, $destLat, $destLng);
        }

        $route = Http::withHeaders([
            'X-Goog-Api-Key' => $key,
            'X-Goog-FieldMask' => 'routes.duration,routes.polyline.encodedPolyline',
        ])->post(self::ENDPOINT, [
            'origin' => ['location' => ['latLng' => [
                'latitude' => $originLat, 'longitude' => $originLng,
            ]]],
            'destination' => ['location' => ['latLng' => [
                'latitude' => $destLat, 'longitude' => $destLng,
            ]]],
            'travelMode' => 'DRIVE',
        ])->throw()->json('routes.0');

        $seconds = (int) rtrim($route['duration'], 's');

        return [
            'points' => $this->decodePolyline($route['polyline']['encodedPolyline']),
            'duration_minutes' => max(1, intdiv($seconds + 59, 60)),
        ];
    }

    /**
     * L'algorithme de polyline encodée de Google, décodé à la main —
     * ~25 lignes, pas besoin d'un package.
     *
     * @return list<array{float, float}>
     */
    public function decodePolyline(string $encoded): array
    {
        $points = [];
        $index = 0;
        $lat = 0;
        $lng = 0;
        $length = strlen($encoded);

        while ($index < $length) {
            foreach ([&$lat, &$lng] as &$coordinate) {
                $result = 0;
                $shift = 0;
                do {
                    $byte = ord($encoded[$index++]) - 63;
                    $result |= ($byte & 0x1F) << $shift;
                    $shift += 5;
                } while ($byte >= 0x20);
                $coordinate += ($result & 1) ? ~($result >> 1) : ($result >> 1);
            }
            unset($coordinate);

            $points[] = [$lat * 1e-5, $lng * 1e-5];
        }

        return $points;
    }

    /**
     * Sans clé Maps (dev local, facturation Google pas encore activée —
     * voir DETTE.md) : ligne droite + durée estimée à 25 km/h urbains.
     * Suffisant pour développer ; la prod exige la clé.
     *
     * @return array{points: list<array{float, float}>, duration_minutes: int}
     */
    private function approximate(
        float $originLat,
        float $originLng,
        float $destLat,
        float $destLng,
    ): array {
        Log::warning('GOOGLE_MAPS_API_KEY absente : itinéraire approximé en ligne droite.');

        $earthRadius = 6371000;
        $dLat = deg2rad($destLat - $originLat);
        $dLng = deg2rad($destLng - $originLng);
        $a = sin($dLat / 2) ** 2
            + cos(deg2rad($originLat)) * cos(deg2rad($destLat)) * sin($dLng / 2) ** 2;
        $meters = 2 * $earthRadius * asin(sqrt($a));

        $roadMeters = $meters * 1.3;

        return [
            'points' => [[$originLat, $originLng], [$destLat, $destLng]],
            'duration_minutes' => max(1, (int) round($roadMeters / 1000 / 25 * 60)),
        ];
    }
}
