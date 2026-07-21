<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class MeTest extends TestCase
{
    use RefreshDatabase;

    private function authed(User $user): array
    {
        return ['Authorization' => 'Bearer '.$user->createToken('t')->plainTextToken];
    }

    public function test_profile_can_be_updated(): void
    {
        $user = User::factory()->create(['first_name' => '', 'last_name' => '']);

        $response = $this->patchJson('/api/me', [
            'first_name' => 'Awa',
            'last_name' => 'Ndiaye',
            'role' => 'both',
        ], $this->authed($user));

        $response->assertOk()
            ->assertJsonPath('data.first_name', 'Awa')
            ->assertJsonPath('data.role', 'both');
    }

    public function test_rating_and_counters_can_never_be_written_by_the_client(): void
    {
        $user = User::factory()->create();

        $this->patchJson('/api/me', [
            'first_name' => 'Awa',
            'rating' => 5,
            'rating_count' => 999,
            'trips_completed' => 999,
        ], $this->authed($user))->assertOk();

        $fresh = $user->fresh();
        $this->assertSame('0.0', (string) $fresh->rating);
        $this->assertSame(0, $fresh->rating_count);
        $this->assertSame(0, $fresh->trips_completed);
    }

    public function test_invalid_role_is_rejected_in_french(): void
    {
        $user = User::factory()->create();

        $this->patchJson('/api/me', ['role' => 'pilote'], $this->authed($user))
            ->assertUnprocessable()
            ->assertJsonPath('errors.role.0', 'Choisis conducteur, passager, ou les deux.');
    }

    public function test_photo_is_stored_resized_and_recompressed(): void
    {
        Storage::fake('public');
        $user = User::factory()->create();

        $response = $this->postJson('/api/me/photo', [
            'photo' => UploadedFile::fake()->image('selfie.png', 2000, 1500),
        ], $this->authed($user));

        $response->assertOk();
        $url = $response->json('data.photo_url');
        $this->assertNotNull($url);

        $path = 'photos/'.basename($url);
        Storage::disk('public')->assertExists($path);

        [$width, $height] = getimagesizefromstring(
            Storage::disk('public')->get($path),
        );
        $this->assertSame(800, max($width, $height));
        $this->assertSame(
            'image/jpeg',
            getimagesizefromstring(Storage::disk('public')->get($path))['mime'],
        );
    }

    public function test_new_photo_replaces_the_previous_one(): void
    {
        Storage::fake('public');
        $user = User::factory()->create();

        $first = $this->postJson('/api/me/photo', [
            'photo' => UploadedFile::fake()->image('un.jpg', 900, 900),
        ], $this->authed($user))->json('data.photo_url');

        $this->postJson('/api/me/photo', [
            'photo' => UploadedFile::fake()->image('deux.jpg', 900, 900),
        ], $this->authed($user))->assertOk();

        Storage::disk('public')->assertMissing('photos/'.basename($first));
    }

    public function test_fcm_token_can_be_stored(): void
    {
        $user = User::factory()->create();

        $this->postJson('/api/me/fcm-token', [
            'fcm_token' => 'token-fcm-123',
        ], $this->authed($user))->assertOk();

        $this->assertSame('token-fcm-123', $user->fresh()->fcm_token);
    }

    public function test_me_endpoints_require_authentication(): void
    {
        $this->patchJson('/api/me', [])->assertUnauthorized();
        $this->postJson('/api/me/photo', [])->assertUnauthorized();
        $this->postJson('/api/me/fcm-token', [])->assertUnauthorized();
    }
}
