<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreRatingRequest;
use App\Http\Resources\RatingResource;
use App\Models\Booking;
use App\Services\RatingService;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Gate;

class RatingController extends Controller
{
    public function store(StoreRatingRequest $request, RatingService $ratings): JsonResponse
    {
        $booking = Booking::with('trip')->findOrFail($request->validated('booking_id'));

        Gate::authorize('rate', $booking);

        $rating = $ratings->rate(
            $request->user(),
            $booking,
            $request->validated('score'),
            $request->validated('tags', []),
            $request->validated('comment'),
        );

        return RatingResource::make($rating)->response()->setStatusCode(201);
    }
}
