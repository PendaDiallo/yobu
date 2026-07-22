<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * GET /api/trips/price-hint?origin=lat,lng&destination=lat,lng
 */
class PriceHintRequest extends FormRequest
{
    private const LAT_LNG = '/^-?\d{1,2}(\.\d+)?,-?\d{1,3}(\.\d+)?$/';

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'origin' => ['required', 'regex:'.self::LAT_LNG],
            'destination' => ['required', 'regex:'.self::LAT_LNG],
        ];
    }

    /** @return array{float, float} */
    public function originCoordinates(): array
    {
        return $this->parse('origin');
    }

    /** @return array{float, float} */
    public function destinationCoordinates(): array
    {
        return $this->parse('destination');
    }

    /** @return array{float, float} */
    private function parse(string $key): array
    {
        [$lat, $lng] = explode(',', $this->validated($key));

        return [(float) $lat, (float) $lng];
    }
}
