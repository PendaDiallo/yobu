<?php

use App\Console\Commands\CompletePastRides;
use App\Console\Commands\SendDailyReminders;
use Illuminate\Support\Facades\Schedule;

// Le rappel du matin. Le crontab du VPS lance `schedule:run` chaque minute
// (cf docs/07-deploiement.md §9) — c'est lui qui déclenche ceci à 5h30 Dakar.
Schedule::command(SendDailyReminders::class)
    ->dailyAt('05:30')
    ->timezone('Africa/Dakar');

// Clôture des trajets passés + montée des compteurs, en tâche de fond.
Schedule::command(CompletePastRides::class)
    ->everyThirtyMinutes();
