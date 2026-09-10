<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RateLimitTest extends TestCase
{
    use RefreshDatabase;

    private function authed(User $user): array
    {
        return ['Authorization' => 'Bearer '.$user->createToken('t')->plainTextToken];
    }

    public function test_auth_firebase_is_throttled_to_five_per_minute(): void
    {
        for ($i = 0; $i < 5; $i++) {
            $this->postJson('/api/auth/firebase', ['id_token' => 'x'])
                ->assertStatus(401); // token bidon rejeté, mais la requête compte
        }

        $this->postJson('/api/auth/firebase', ['id_token' => 'x'])
            ->assertStatus(429);
    }

    public function test_search_is_throttled_to_thirty_per_minute(): void
    {
        $headers = $this->authed(User::factory()->create());

        for ($i = 0; $i < 30; $i++) {
            $this->postJson('/api/trips/search', [], $headers)
                ->assertStatus(422); // params manquants, mais la requête compte
        }

        $this->postJson('/api/trips/search', [], $headers)
            ->assertStatus(429);
    }
}
