<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Kreait\Firebase\Contract\Auth as FirebaseAuth;
use Kreait\Firebase\Exception\Auth\FailedToVerifyToken;
use Lcobucci\JWT\Token\DataSet;
use Lcobucci\JWT\UnencryptedToken;
use Mockery;
use Mockery\MockInterface;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    private function mockFirebaseVerifying(string $uid, ?string $phone): void
    {
        $token = Mockery::mock(UnencryptedToken::class);
        $token->allows('claims')->andReturn(new DataSet(
            array_filter(['sub' => $uid, 'phone_number' => $phone]),
            '',
        ));

        $this->mock(FirebaseAuth::class, function (MockInterface $mock) use ($token) {
            $mock->allows('verifyIdToken')->andReturn($token);
        });
    }

    public function test_first_login_creates_the_user_and_returns_a_sanctum_token(): void
    {
        $this->mockFirebaseVerifying('firebase-uid-1', '+221771234567');

        $response = $this->postJson('/api/auth/firebase', ['id_token' => 'fake']);

        $response->assertOk()
            ->assertJsonStructure(['token', 'user' => ['id', 'phone', 'badges']])
            ->assertJsonPath('user.phone', '+221771234567')
            ->assertJsonPath('user.badges', ['phone_verified']);

        $this->assertDatabaseHas('users', [
            'firebase_uid' => 'firebase-uid-1',
            'phone' => '+221771234567',
        ]);
    }

    public function test_second_login_reuses_the_existing_user(): void
    {
        $user = User::factory()->create(['firebase_uid' => 'firebase-uid-1']);
        $this->mockFirebaseVerifying('firebase-uid-1', $user->phone);

        $response = $this->postJson('/api/auth/firebase', ['id_token' => 'fake']);

        $response->assertOk()->assertJsonPath('user.id', $user->id);
        $this->assertDatabaseCount('users', 1);
    }

    public function test_the_sanctum_token_authenticates_follow_up_requests(): void
    {
        $this->mockFirebaseVerifying('firebase-uid-1', '+221771234567');

        $token = $this->postJson('/api/auth/firebase', ['id_token' => 'fake'])
            ->json('token');

        $this->getJson('/api/me', ['Authorization' => "Bearer $token"])
            ->assertOk()
            ->assertJsonPath('data.phone', '+221771234567');
    }

    public function test_an_invalid_firebase_token_is_rejected(): void
    {
        $this->mock(FirebaseAuth::class, function (MockInterface $mock) {
            $mock->allows('verifyIdToken')
                ->andThrow(new FailedToVerifyToken('expired'));
        });

        $this->postJson('/api/auth/firebase', ['id_token' => 'bad'])
            ->assertUnauthorized();

        $this->assertDatabaseCount('users', 0);
    }

    public function test_a_token_without_phone_number_is_rejected(): void
    {
        $this->mockFirebaseVerifying('firebase-uid-1', null);

        $this->postJson('/api/auth/firebase', ['id_token' => 'fake'])
            ->assertUnauthorized();

        $this->assertDatabaseCount('users', 0);
    }

    public function test_same_phone_with_new_firebase_uid_relinks_the_account(): void
    {
        // Compte Firebase supprimé puis recréé : même numéro, nouvel uid.
        $user = User::factory()->create([
            'firebase_uid' => 'old-uid',
            'phone' => '+221771234567',
            'first_name' => 'Awa',
        ]);
        $this->mockFirebaseVerifying('new-uid', '+221771234567');

        $response = $this->postJson('/api/auth/firebase', ['id_token' => 'fake']);

        $response->assertOk()->assertJsonPath('user.id', $user->id);
        $this->assertDatabaseCount('users', 1);
        $this->assertSame('new-uid', $user->fresh()->firebase_uid);
        $this->assertSame('Awa', $user->fresh()->first_name); // le profil survit
    }

    public function test_me_requires_authentication(): void
    {
        $this->getJson('/api/me')->assertUnauthorized();
    }

    public function test_regular_badge_appears_at_ten_trips(): void
    {
        $user = User::factory()->create(['trips_completed' => 10]);

        $this->getJson('/api/me', [
            'Authorization' => 'Bearer '.$user->createToken('t')->plainTextToken,
        ])
            ->assertOk()
            ->assertJsonPath('data.badges', ['phone_verified', 'regular']);
    }
}
