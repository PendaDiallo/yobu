<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'firebase_uid',
        'phone',
        'first_name',
        'last_name',
        'photo_url',
        'role',
        'fcm_token',
    ];
    // rating, rating_count, trips_completed : écrits par les Services, jamais
    // en mass assignment.

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'rating' => 'decimal:1',
        ];
    }

    /** Les trajets récurrents publiés en tant que conducteur. */
    public function trips(): HasMany
    {
        return $this->hasMany(Trip::class, 'driver_id');
    }

    /** Les réservations faites en tant que passager. */
    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class, 'rider_id');
    }

    public function ratingsGiven(): HasMany
    {
        return $this->hasMany(Rating::class, 'from_user_id');
    }

    public function ratingsReceived(): HasMany
    {
        return $this->hasMany(Rating::class, 'to_user_id');
    }
}
