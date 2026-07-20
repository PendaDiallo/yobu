<?php

namespace App\Casts;

use Illuminate\Contracts\Database\Eloquent\CastsAttributes;
use Illuminate\Database\Eloquent\Model;

/**
 * Cast PHP array ↔ tableau Postgres ({1,2,3} ou {ponctuel,sympa}).
 *
 * Suffit pour nos deux colonnes (smallint[], varchar[] de slugs) : valeurs
 * sans virgule, accolade ni guillemet. Pas un parseur générique — exprès.
 */
class PgArray implements CastsAttributes
{
    public function get(Model $model, string $key, mixed $value, array $attributes): ?array
    {
        if ($value === null) {
            return null;
        }

        $inner = trim((string) $value, '{}');
        if ($inner === '') {
            return [];
        }

        return array_map(
            fn (string $item) => is_numeric($item) ? (int) $item : trim($item, '"'),
            explode(',', $inner),
        );
    }

    public function set(Model $model, string $key, mixed $value, array $attributes): ?string
    {
        if ($value === null) {
            return null;
        }

        return '{'.implode(',', $value).'}';
    }
}
