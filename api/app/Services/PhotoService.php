<?php

namespace App\Services;

use App\Models\User;
use GdImage;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

/**
 * Photo de profil : recadrage à 800 px max (côté le plus long), JPEG 80 %.
 * En GD pur — pas de dépendance pour 30 lignes de traitement.
 */
class PhotoService
{
    private const MAX_DIMENSION = 800;

    private const JPEG_QUALITY = 80;

    public function store(User $user, UploadedFile $file): User
    {
        $image = imagecreatefromstring($file->getContent());

        $image = $this->applyExifOrientation($image, $file);

        $width = imagesx($image);
        $height = imagesy($image);
        if (max($width, $height) > self::MAX_DIMENSION) {
            $ratio = self::MAX_DIMENSION / max($width, $height);
            $image = imagescale($image, (int) round($width * $ratio));
        }

        ob_start();
        imagejpeg($image, null, self::JPEG_QUALITY);
        $jpeg = (string) ob_get_clean();

        $path = sprintf('photos/%d-%s.jpg', $user->id, Str::random(8));
        Storage::disk('public')->put($path, $jpeg);

        $this->deletePrevious($user);
        $user->update(['photo_url' => Storage::disk('public')->url($path)]);

        return $user;
    }

    /**
     * Les photos de téléphone portent leur rotation en EXIF, que GD ignore :
     * sans ça, un portrait arrive couché.
     */
    private function applyExifOrientation(GdImage $image, UploadedFile $file): GdImage
    {
        if ($file->getMimeType() !== 'image/jpeg' || ! function_exists('exif_read_data')) {
            return $image;
        }

        $orientation = @exif_read_data($file->getRealPath())['Orientation'] ?? 1;

        return match ($orientation) {
            3 => imagerotate($image, 180, 0),
            6 => imagerotate($image, -90, 0),
            8 => imagerotate($image, 90, 0),
            default => $image,
        };
    }

    private function deletePrevious(User $user): void
    {
        $url = $user->photo_url;
        if ($url === null || ! str_contains($url, '/storage/')) {
            return;
        }

        Storage::disk('public')->delete(Str::after($url, '/storage/'));
    }
}
