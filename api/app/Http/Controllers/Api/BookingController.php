<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreBookingRequest;
use App\Http\Requests\UpdateBookingRequest;
use App\Http\Resources\BookingResource;
use App\Models\Booking;
use App\Models\Trip;
use App\Services\BookingService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\ValidationException;

class BookingController extends Controller
{
    public function store(
        StoreBookingRequest $request,
        BookingService $bookings,
    ): JsonResponse {
        $trip = Trip::findOrFail($request->validated('trip_id'));

        $booking = $bookings->request(
            $request->user(),
            $trip,
            $request->validated('date'),
        );
        $booking->load('trip.driver');

        return BookingResource::make($booking)->response()->setStatusCode(201);
    }

    /** Mes réservations (passager). */
    public function index(Request $request): AnonymousResourceCollection
    {
        $bookings = Booking::with('trip.driver')
            ->where('rider_id', $request->user()->id)
            ->orderByDesc('date')
            ->get();

        return BookingResource::collection($bookings);
    }

    /** Demandes reçues (conducteur), les pending d'abord. */
    public function received(Request $request): AnonymousResourceCollection
    {
        $bookings = Booking::with(['trip.driver', 'rider'])
            ->whereHas('trip', fn ($query) => $query
                ->where('driver_id', $request->user()->id))
            ->orderByRaw("(status = 'pending') DESC")
            ->orderBy('date')
            ->get();

        return BookingResource::collection($bookings);
    }

    public function update(
        UpdateBookingRequest $request,
        Booking $booking,
        BookingService $bookings,
    ): BookingResource {
        $status = $request->validated('status');

        if ($status === 'cancelled') {
            Gate::authorize('cancel', $booking);
            $this->assertTransition($booking, ['pending', 'accepted']);
            $booking->update(['status' => 'cancelled']);
        } else {
            Gate::authorize('respond', $booking);
            $this->assertTransition($booking, ['pending']);
            $status === 'accepted'
                ? $bookings->accept($booking)
                : $booking->update(['status' => 'rejected']);
        }

        return BookingResource::make($booking->load(['trip.driver', 'rider']));
    }

    /**
     * @param  list<string>  $allowedCurrent
     */
    private function assertTransition(Booking $booking, array $allowedCurrent): void
    {
        if (! in_array($booking->status, $allowedCurrent, true)) {
            throw ValidationException::withMessages([
                'status' => 'Cette demande a déjà été traitée.',
            ]);
        }
    }
}
