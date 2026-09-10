<?php

namespace App\Http\Requests;

use App\Models\Rating;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreRatingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // l'autorisation métier passe par RatingPolicy dans le contrôleur
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'booking_id' => ['required', 'integer', 'exists:bookings,id'],
            'score' => ['required', 'integer', 'between:1,5'],
            'tags' => ['array'],
            'tags.*' => [Rule::in(Rating::TAGS)],
            'comment' => ['nullable', 'string', 'max:500'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'booking_id.exists' => 'Ce trajet n\'existe pas.',
            'score.between' => 'La note va de 1 à 5.',
        ];
    }
}
