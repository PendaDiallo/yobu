<?php

namespace App\Providers;

use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        Model::preventLazyLoading(! $this->app->isProduction());

        // HTTPS forcé dès que l'API tourne sous un domaine https (Caddy termine
        // le TLS). Dormant tant que le VPS est en http nu (cf docs/DETTE.md,
        // 06/09) — s'active tout seul le jour du domaine.
        if (str_starts_with((string) config('app.url'), 'https://')) {
            URL::forceScheme('https');
        }

        // Limites de débit (J18). Clé = user connecté, sinon IP.
        RateLimiter::for('api', fn (Request $request) => Limit::perMinute(60)
            ->by($request->user()?->id ?: $request->ip()));

        // L'échange de token Firebase : public, et il déclenche une vérif
        // Google. On borne serré, par IP.
        RateLimiter::for('firebase-auth', fn (Request $request) => Limit::perMinute(5)
            ->by($request->ip()));

        // Le matching : une requête PostGIS + la métrique n°1. Modéré, par user.
        RateLimiter::for('search', fn (Request $request) => Limit::perMinute(30)
            ->by($request->user()?->id ?: $request->ip()));
    }
}
