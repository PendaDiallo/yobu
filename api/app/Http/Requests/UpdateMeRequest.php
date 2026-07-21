<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateMeRequest extends FormRequest
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
        // rating, rating_count, trips_completed : jamais acceptés ici — ils
        // n'existent ni dans les règles ni dans $fillable côté modèle.
        return [
            'first_name' => ['sometimes', 'required', 'string', 'max:60'],
            'last_name' => ['sometimes', 'required', 'string', 'max:60'],
            'role' => ['sometimes', 'required', 'in:driver,rider,both'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'first_name.required' => 'Ton prénom est requis.',
            'last_name.required' => 'Ton nom est requis.',
            'role.in' => 'Choisis conducteur, passager, ou les deux.',
        ];
    }
}
