<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        // Un seul ingress : Caddy, sur le même hôte, qui termine le TLS et
        // transmet X-Forwarded-Proto. On lui fait confiance pour que
        // $request->isSecure() dise vrai derrière le proxy.
        $middleware->trustProxies(at: '*');
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        // Les routes API répondent TOUJOURS en JSON — jamais de redirect vers
        // une page login inexistante. Un token manquant => 401 propre, pas 500.
        $exceptions->shouldRenderJsonWhen(
            fn ($request, $throwable) => $request->is('api/*') || $request->expectsJson(),
        );
    })->create();
