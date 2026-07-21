<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\FirebaseAuthRequest;
use App\Http\Resources\UserResource;
use App\Services\FirebaseAuthService;
use Illuminate\Http\JsonResponse;

class AuthController extends Controller
{
    public function firebase(
        FirebaseAuthRequest $request,
        FirebaseAuthService $service,
    ): JsonResponse {
        $result = $service->authenticate($request->validated('id_token'));

        return response()->json([
            'token' => $result['token'],
            'user' => UserResource::make($result['user']),
        ]);
    }
}
