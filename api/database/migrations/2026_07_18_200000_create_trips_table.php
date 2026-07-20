<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Le trajet RÉCURRENT du conducteur (docs/02-technique.md §3).
     *
     * Les 3 pièges du modèle :
     * - departure_time est un TIME, pas un timestamp — un trajet récurrent
     *   n'a pas de date ;
     * - seats_total ne se décrémente JAMAIS — les places se calculent par
     *   date (§5) ;
     * - geography (pas geometry) : les distances sont en mètres.
     */
    public function up(): void
    {
        Schema::create('trips', function (Blueprint $table) {
            $table->id();
            $table->foreignId('driver_id')->constrained('users');
            $table->string('origin_label');
            $table->geography('origin_point', subtype: 'point', srid: 4326);
            $table->string('dest_label');
            $table->geography('dest_point', subtype: 'point', srid: 4326);
            // Polyline Routes API, décodée à la création du trajet.
            $table->geography('route', subtype: 'linestring', srid: 4326);
            $table->time('departure_time'); // "06:45" — PAS un timestamp
            $table->integer('duration_minutes'); // renvoyé par Routes API à la création
            $table->smallInteger('seats_total'); // par occurrence. JAMAIS décrémenté.
            $table->integer('price_per_seat'); // FCFA
            $table->boolean('active')->default(true);
            $table->timestamps();
        });

        // {1,2,3,4,5}, lundi=1 — pas de type array dans le schema builder.
        DB::statement('ALTER TABLE trips ADD COLUMN days_of_week smallint[] NOT NULL');

        DB::statement('CREATE INDEX trips_route_gix ON trips USING GIST (route)');
        DB::statement('CREATE INDEX trips_dest_gix ON trips USING GIST (dest_point)');
        DB::statement('CREATE INDEX trips_active_days_idx ON trips (active) INCLUDE (days_of_week)');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('trips');
    }
};
