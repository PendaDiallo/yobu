<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTripRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // l'autorisation métier passe par TripPolicy::create
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'origin_label' => ['required', 'string', 'max:120'],
            'origin_lat' => ['required', 'numeric', 'between:-90,90'],
            'origin_lng' => ['required', 'numeric', 'between:-180,180'],
            'dest_label' => ['required', 'string', 'max:120'],
            'dest_lat' => ['required', 'numeric', 'between:-90,90'],
            'dest_lng' => ['required', 'numeric', 'between:-180,180'],
            'departure_time' => ['required', 'date_format:H:i'],
            'days_of_week' => ['required', 'array', 'min:1'],
            'days_of_week.*' => ['integer', 'between:1,7', 'distinct'],
            'seats_total' => ['required', 'integer', 'between:1,4'],
            'price_per_seat' => ['required', 'integer', 'min:100', 'max:10000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'origin_label.required' => 'Indique ton point de départ.',
            'dest_label.required' => 'Indique ta destination.',
            'departure_time.date_format' => 'L\'heure doit être au format 06:45.',
            'days_of_week.required' => 'Choisis au moins un jour.',
            'days_of_week.*.between' => 'Les jours vont de 1 (lundi) à 7 (dimanche).',
            'seats_total.between' => 'Entre 1 et 4 places.',
            'price_per_seat.min' => 'Le prix minimum est de 100 F.',
            'price_per_seat.max' => 'Ce prix dépasse largement le partage de frais.',
        ];
    }
}
