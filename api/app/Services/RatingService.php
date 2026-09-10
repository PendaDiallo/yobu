<?php

namespace App\Services;

use App\Models\Booking;
use App\Models\Rating;
use App\Models\User;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * La notation post-trajet. Les DEUX participants notent, chacun une fois —
 * c'est la contrainte `UNIQUE (booking_id, from_user_id)` qui le garantit,
 * pas un `if`. La note moyenne du destinataire est recalculée en
 * transaction, jamais écrite depuis le client.
 */
class RatingService
{
    /**
     * @param  list<string>  $tags
     *
     * @throws ValidationException  si l'auteur a déjà noté ce trajet
     */
    public function rate(
        User $author,
        Booking $booking,
        int $score,
        array $tags,
        ?string $comment,
    ): Rating {
        $booking->loadMissing('trip');

        $toUserId = $author->id === $booking->rider_id
            ? $booking->trip->driver_id
            : $booking->rider_id;

        return DB::transaction(function () use ($author, $booking, $toUserId, $score, $tags, $comment): Rating {
            try {
                $rating = Rating::create([
                    'booking_id' => $booking->id,
                    'from_user_id' => $author->id,
                    'to_user_id' => $toUserId,
                    'score' => $score,
                    'tags' => $tags,
                    'comment' => $comment,
                ]);
            } catch (UniqueConstraintViolationException) {
                throw ValidationException::withMessages([
                    'booking_id' => 'Tu as déjà noté ce trajet.',
                ]);
            }

            $target = User::whereKey($toUserId)->lockForUpdate()->first();

            $aggregate = Rating::where('to_user_id', $toUserId)
                ->selectRaw('COUNT(*) AS count, AVG(score) AS average')
                ->first();

            $target->forceFill([
                'rating' => round((float) $aggregate->average, 1),
                'rating_count' => (int) $aggregate->count,
            ])->save();

            return $rating;
        });
    }
}
