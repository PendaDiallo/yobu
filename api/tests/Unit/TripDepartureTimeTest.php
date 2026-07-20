<?php

namespace Tests\Unit;

use App\Models\Trip;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * Le piège n°1 du modèle (docs/02-technique.md §3) : un trajet récurrent n'a
 * pas de date. Si departure_time devient un timestamp — en base ou via un
 * cast datetime — tout le modèle est contaminé. Ce test verrouille les deux.
 */
class TripDepartureTimeTest extends TestCase
{
    use RefreshDatabase;

    public function test_departure_time_column_is_a_time_not_a_timestamp(): void
    {
        $type = DB::selectOne(
            'SELECT data_type FROM information_schema.columns
             WHERE table_name = ? AND column_name = ?',
            ['trips', 'departure_time'],
        )->data_type;

        $this->assertSame('time without time zone', $type);
    }

    public function test_departure_time_stays_a_plain_time_string_on_the_model(): void
    {
        $trip = Trip::factory()->create(['departure_time' => '06:45']);

        $value = $trip->fresh()->departure_time;

        $this->assertIsString($value);
        $this->assertSame('06:45:00', $value);
    }
}
