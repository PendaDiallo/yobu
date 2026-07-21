<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class FirebaseAuthRequest extends FormRequest
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
            'id_token' => ['required', 'string'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'id_token.required' => 'Le jeton d\'authentification est requis.',
        ];
    }
}
