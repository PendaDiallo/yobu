<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Throwable;

class HealthController extends Controller
{
    public function __invoke(): JsonResponse
    {
        try {
            $postgis = DB::selectOne('SELECT PostGIS_Version() AS version')->version;
        } catch (Throwable) {
            return response()->json(['ok' => false], 503);
        }

        return response()->json(['ok' => true, 'postgis' => $postgis]);
    }
}
