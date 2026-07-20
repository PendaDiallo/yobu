<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Une occurrence, un jour donné. Le TRAJET est récurrent, la réservation
     * est ponctuelle — pas de champ recurring (docs/02-technique.md §3).
     */
    public function up(): void
    {
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('trip_id')->constrained('trips');
            $table->foreignId('rider_id')->constrained('users');
            $table->date('date'); // LE jour concerné
            $table->enum('status', [
                'pending', 'accepted', 'rejected', 'cancelled', 'completed',
            ]);
            $table->smallInteger('seats')->default(1);
            $table->integer('price_paid');
            $table->timestamps();

            // Pas deux demandes le même jour.
            $table->unique(['trip_id', 'rider_id', 'date']);
            $table->index(['trip_id', 'date', 'status'], 'bookings_trip_date');
        });

        // DESC : hors de portée du schema builder.
        DB::statement('CREATE INDEX bookings_rider_date ON bookings (rider_id, date DESC)');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bookings');
    }
};
