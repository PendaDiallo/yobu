<?php

namespace App\Exceptions;

use Exception;
use Illuminate\Http\JsonResponse;

/**
 * Levée pendant l'acceptation (docs/02-technique.md §5) quand la dernière
 * place vient de partir. Le seul endroit de la V1 où une race condition
 * laisserait quelqu'un sur le trottoir à 6h30.
 */
class TripFullException extends Exception
{
    public function render(): JsonResponse
    {
        return response()->json([
            'message' => 'Ce trajet est déjà complet pour ce jour-là.',
        ], 409);
    }
}
