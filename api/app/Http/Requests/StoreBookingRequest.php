<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreBookingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // les règles métier vivent dans BookingService::request
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'trip_id' => ['required', 'integer', 'exists:trips,id'],
            'date' => ['required', 'date_format:Y-m-d', 'after_or_equal:today'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'trip_id.exists' => 'Ce trajet n\'existe plus.',
            'date.after_or_equal' => 'La date est déjà passée.',
        ];
    }
}
