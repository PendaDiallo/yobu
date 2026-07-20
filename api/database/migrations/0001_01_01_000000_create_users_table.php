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
        // L'image postgis/postgis la crée déjà en local ; indispensable en prod.
        DB::statement('CREATE EXTENSION IF NOT EXISTS postgis');

        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('firebase_uid')->unique();
            $table->string('phone')->unique(); // +221...
            $table->string('first_name');
            $table->string('last_name');
            $table->string('photo_url')->nullable();
            $table->enum('role', ['driver', 'rider', 'both'])->nullable();
            // Écrit par RatingService UNIQUEMENT.
            $table->decimal('rating', 2, 1)->default(0);
            $table->integer('rating_count')->default(0);
            $table->integer('trips_completed')->default(0);
            $table->string('fcm_token')->nullable();
            $table->timestamps();
            // Pas de colonne badges : ils sont dérivés (docs/02-technique.md §4ter).
        });

        // Auth par OTP Firebase : ni email, ni password, ni reset de mot de passe.
        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('sessions');
    }
};
