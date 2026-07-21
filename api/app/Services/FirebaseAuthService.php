<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Auth\AuthenticationException;
use Kreait\Firebase\Contract\Auth as FirebaseAuth;
use Kreait\Firebase\Exception\Auth\FailedToVerifyToken;

/**
 * Le seul endroit où Firebase et Laravel se parlent (docs/02-technique.md §2).
 * Le token Firebase ne sert qu'une fois, ici — ensuite c'est du Sanctum.
 */
class FirebaseAuthService
{
    public function __construct(private readonly FirebaseAuth $firebase) {}

    /**
     * Vérifie l'ID token Firebase et renvoie l'utilisateur + un token Sanctum.
     *
     * @return array{token: string, user: User}
     *
     * @throws AuthenticationException
     */
    public function authenticate(string $idToken): array
    {
        try {
            $claims = $this->firebase->verifyIdToken($idToken)->claims();
        } catch (FailedToVerifyToken) {
            throw new AuthenticationException('Connexion impossible. Réessaie de te connecter.');
        }

        $phone = $claims->get('phone_number');
        if ($phone === null) {
            // L'auth YOBU EST un OTP téléphone : un jeton sans numéro n'a
            // rien à faire ici.
            throw new AuthenticationException('Connexion impossible. Réessaie de te connecter.');
        }

        $uid = $claims->get('sub');

        $user = User::where('firebase_uid', $uid)->first();

        if ($user === null) {
            // Même numéro, nouvel uid (compte Firebase supprimé puis recréé) :
            // l'OTP vient de prouver la possession du numéro, on relie le
            // compte existant au lieu de violer l'unicité du téléphone.
            $user = User::where('phone', $phone)->first();
            $user?->update(['firebase_uid' => $uid]);
        }

        if ($user === null) {
            $user = User::create([
                'firebase_uid' => $uid,
                'phone' => $phone,
                // Renseignés par l'écran profile_setup, juste après le premier login.
                'first_name' => '',
                'last_name' => '',
            ])->refresh(); // récupère les defaults DB (rating, compteurs)
        }

        return [
            'token' => $user->createToken('mobile')->plainTextToken,
            'user' => $user,
        ];
    }
}
