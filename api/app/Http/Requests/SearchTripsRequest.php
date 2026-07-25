<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SearchTripsRequest extends FormRequest
{
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
            'origin_lat' => ['required', 'numeric', 'between:-90,90'],
            'origin_lng' => ['required', 'numeric', 'between:-180,180'],
            'dest_lat' => ['required', 'numeric', 'between:-90,90'],
            'dest_lng' => ['required', 'numeric', 'between:-180,180'],
            'arrival_before' => ['required', 'date_format:H:i'],
            'date' => ['required', 'date_format:Y-m-d'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'arrival_before.date_format' => 'L\'heure doit être au format 08:00.',
            'date.date_format' => 'La date doit être au format 2026-08-03.',
        ];
    }
}
