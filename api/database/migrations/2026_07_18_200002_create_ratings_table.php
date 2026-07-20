<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('ratings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('booking_id')->constrained('bookings');
            $table->foreignId('from_user_id')->constrained('users');
            $table->foreignId('to_user_id')->constrained('users');
            $table->smallInteger('score');
            $table->text('comment')->nullable();
            $table->timestamp('created_at')->nullable();

            // Chacun note l'autre, une seule fois.
            $table->unique(['booking_id', 'from_user_id']);
        });

        DB::statement('ALTER TABLE ratings ADD CONSTRAINT ratings_score_check CHECK (score BETWEEN 1 AND 5)');
        // {ponctuel,sympa,conduite_sure,voiture_propre}
        DB::statement('ALTER TABLE ratings ADD COLUMN tags varchar[]');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ratings');
    }
};
