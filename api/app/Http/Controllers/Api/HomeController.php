<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\HomeService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function __invoke(Request $request, HomeService $home): JsonResponse
    {
        return response()->json([
            'next' => $home->nextRide($request->user()),
        ]);
    }
}
