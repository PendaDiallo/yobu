<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\HealthController;
use App\Http\Controllers\Api\MeController;
use App\Http\Controllers\Api\TripController;
use Illuminate\Support\Facades\Route;

Route::get('/health', HealthController::class);

Route::post('/auth/firebase', [AuthController::class, 'firebase']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [MeController::class, 'show']);
    Route::patch('/me', [MeController::class, 'update']);
    Route::post('/me/photo', [MeController::class, 'storePhoto']);
    Route::post('/me/fcm-token', [MeController::class, 'storeFcmToken']);

    // Les routes fixes avant le paramètre {trip}.
    Route::get('/trips/price-hint', [TripController::class, 'priceHint']);
    Route::get('/trips/mine', [TripController::class, 'mine']);
    Route::post('/trips', [TripController::class, 'store']);
    Route::patch('/trips/{trip}', [TripController::class, 'update']);
    Route::delete('/trips/{trip}', [TripController::class, 'destroy']);
});
