<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateTripRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // TripPolicy::update
    }

    /**
     * Un trajet récurrent ne se modifie pas : il s'active/se désactive
     * (docs/01-produit.md — trip_my_list). Pour changer l'itinéraire,
     * on republie.
     *
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'active' => ['required', 'boolean'],
        ];
    }
}
