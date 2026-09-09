<?php

namespace Tests\Feature;

use App\Jobs\SendPushNotification;
use App\Models\Booking;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Bus;
use Tests\TestCase;

class DailyRemindersTest extends TestCase
{
    use RefreshDatabase;

    private function today(): string
    {
        // Un jour ouvré : les trajets du corridor roulent lun-ven.
        $day = Carbon::now('Africa/Dakar');
        while ($day->isWeekend()) {
            $day = $day->addDay();
        }

        return $day->toDateString();
    }

    public function test_it_reminds_riders_and_one_reminder_per_driver(): void
    {
        Bus::fake();

        $trip = Trip::factory()->create(['seats_total' => 4]);
        $today = $this->today();

        // 2 passagers acceptés aujourd'hui sur le même trajet.
        $riderA = User::factory()->create();
        $riderB = User::factory()->create();
        Booking::factory()->for($trip)->for($riderA, 'rider')
            ->create(['status' => 'accepted', 'date' => $today]);
        Booking::factory()->for($trip)->for($riderB, 'rider')
            ->create(['status' => 'accepted', 'date' => $today]);

        // Bruit qui ne doit PAS déclencher de rappel : pending, ou autre jour.
        Booking::factory()->for($trip)->create(['status' => 'pending', 'date' => $today]);
        Booking::factory()->for($trip)->create([
            'status' => 'accepted',
            'date' => Carbon::parse($today, 'Africa/Dakar')->addWeek()->toDateString(),
        ]);

        $this->artisan('app:daily-reminders')->assertSuccessful();

        // 2 passagers + 1 conducteur = 3 push.
        Bus::assertDispatchedTimes(SendPushNotification::class, 3);

        Bus::assertDispatched(
            SendPushNotification::class,
            fn (SendPushNotification $job) => $this->recipientId($job) === $riderA->id,
        );
        Bus::assertDispatched(
            SendPushNotification::class,
            fn (SendPushNotification $job) => $this->recipientId($job) === $trip->driver_id,
        );
    }

    public function test_no_ride_today_sends_nothing(): void
    {
        Bus::fake();

        Booking::factory()->create(['status' => 'accepted', 'date' => $this->today()]);
        // ...mais aucun trajet ne roule ? Non : ré-écrasons le statut.
        Booking::query()->update(['status' => 'pending']);

        $this->artisan('app:daily-reminders')->assertSuccessful();

        Bus::assertNothingDispatched();
    }

    private function recipientId(SendPushNotification $job): int
    {
        $recipient = (new \ReflectionClass($job))->getProperty('recipient');

        return $recipient->getValue($job)->id;
    }
}
