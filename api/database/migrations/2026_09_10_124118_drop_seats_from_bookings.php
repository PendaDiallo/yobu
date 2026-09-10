<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * La colonne `seats` ne portait aucune information : toujours `1`, jamais lue
 * (la capacité se calcule en COUNT(*) des accepted, cf docs/02-technique.md §5).
 * Elle suggérait un multi-place qui n'existe pas en V1 — piège écarté.
 * Le multi-place reviendra proprement en V1.1 (SUM(seats) + validation + UI).
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->dropColumn('seats');
        });
    }

    public function down(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->smallInteger('seats')->default(1);
        });
    }
};
