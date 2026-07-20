<?php

namespace App\Models;

use App\Casts\PgArray;
use Database\Factories\TripFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Le trajet RÉCURRENT du conducteur.
 *
 * departure_time reste une string "HH:MM:SS" — jamais de cast datetime :
 * un trajet récurrent n'a pas de date, un Carbon complet ici est un bug.
 * Les places libres se calculent par date via bookings, jamais en
 * décrémentant seats_total.
 */
class Trip extends Model
{
    /** @use HasFactory<TripFactory> */
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'driver_id',
        'origin_label',
        'origin_point',
        'dest_label',
        'dest_point',
        'route',
        'departure_time',
        'duration_minutes',
        'days_of_week',
        'seats_total',
        'price_per_seat',
        'active',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'days_of_week' => PgArray::class,
            'active' => 'boolean',
        ];
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'driver_id');
    }

    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }
}
