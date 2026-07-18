<?php

namespace Tests\Feature;

use Tests\TestCase;

class HealthTest extends TestCase
{
    public function test_health_reports_ok_and_postgis_version(): void
    {
        $response = $this->getJson('/api/health');

        $response->assertOk()
            ->assertJson(['ok' => true])
            ->assertJsonStructure(['ok', 'postgis']);
    }
}
