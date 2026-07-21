<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreFcmTokenRequest;
use App\Http\Requests\StorePhotoRequest;
use App\Http\Requests\UpdateMeRequest;
use App\Http\Resources\UserResource;
use App\Services\PhotoService;
use Illuminate\Http\Request;

class MeController extends Controller
{
    public function show(Request $request): UserResource
    {
        return UserResource::make($request->user());
    }

    public function update(UpdateMeRequest $request): UserResource
    {
        $user = $request->user();
        $user->update($request->validated());

        return UserResource::make($user);
    }

    public function storePhoto(
        StorePhotoRequest $request,
        PhotoService $photos,
    ): UserResource {
        $user = $photos->store($request->user(), $request->file('photo'));

        return UserResource::make($user);
    }

    public function storeFcmToken(StoreFcmTokenRequest $request): UserResource
    {
        $user = $request->user();
        $user->update($request->validated());

        return UserResource::make($user);
    }
}
