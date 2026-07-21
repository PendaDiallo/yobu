<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePhotoRequest extends FormRequest
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
            'photo' => ['required', 'image', 'mimes:jpeg,png,webp', 'max:8192'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'photo.required' => 'Choisis une photo.',
            'photo.image' => 'Le fichier doit être une image.',
            'photo.mimes' => 'Formats acceptés : JPEG, PNG ou WebP.',
            'photo.max' => 'La photo dépasse 8 Mo.',
        ];
    }
}
