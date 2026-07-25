<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\PriceHintRequest;
use App\Http\Requests\SearchTripsRequest;
use App\Http\Requests\StoreTripRequest;
use App\Http\Requests\UpdateTripRequest;
use App\Http\Resources\MatchResource;
use App\Http\Resources\TripResource;
use App\Models\Trip;
use App\Services\TripMatchingService;
use App\Services\TripService;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Gate;

class TripController extends Controller
{
    public function priceHint(
        PriceHintRequest $request,
        TripService $trips,
    ): JsonResponse {
        [$originLat, $originLng] = $request->originCoordinates();
        [$destLat, $destLng] = $request->destinationCoordinates();

        return response()->json(
            $trips->priceHint($originLat, $originLng, $destLat, $destLng),
        );
    }

    public function store(
        StoreTripRequest $request,
        TripService $trips,
    ): JsonResponse {
        Gate::authorize('create', Trip::class);

        $trip = $trips->create($request->user(), $request->validated());

        return TripResource::make($trip)->response()->setStatusCode(201);
    }

    public function search(
        SearchTripsRequest $request,
        TripMatchingService $matching,
    ): AnonymousResourceCollection {
        $validated = $request->validated();

        return MatchResource::collection($matching->search(
            (float) $validated['origin_lat'],
            (float) $validated['origin_lng'],
            (float) $validated['dest_lat'],
            (float) $validated['dest_lng'],
            $validated['arrival_before'],
            $validated['date'],
        ));
    }

    public function mine(Request $request): AnonymousResourceCollection
    {
        $trips = Trip::withCoordinates()
            ->where('driver_id', $request->user()->id)
            ->orderByDesc('created_at')
            ->get();

        return TripResource::collection($trips);
    }

    public function update(UpdateTripRequest $request, Trip $trip): TripResource
    {
        Gate::authorize('update', $trip);

        $trip->update($request->validated());

        return TripResource::make(Trip::withCoordinates()->findOrFail($trip->id));
    }

    public function destroy(Request $request, Trip $trip): JsonResponse
    {
        Gate::authorize('delete', $trip);

        try {
            $trip->delete();
        } catch (QueryException) {
            // FK bookings : l'historique des passagers ne s'efface pas.
            return response()->json([
                'message' => 'Ce trajet a des réservations : désactive-le plutôt que de le supprimer.',
            ], 409);
        }

        return response()->json(status: 204);
    }
}
