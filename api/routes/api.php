<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\HealthController;
use App\Http\Controllers\Api\MeController;
use Illuminate\Support\Facades\Route;

Route::get('/health', HealthController::class);

Route::post('/auth/firebase', [AuthController::class, 'firebase']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [MeController::class, 'show']);
});
