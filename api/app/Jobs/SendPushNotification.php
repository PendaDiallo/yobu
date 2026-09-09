<?php

namespace App\Jobs;

use App\Models\User;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Kreait\Firebase\Contract\Messaging;
use Kreait\Firebase\Messaging\AndroidConfig;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Throwable;

class SendPushNotification implements ShouldQueue
{
    use Queueable;

    public int $tries = 3;

    public function __construct(
        private readonly User   $recipient,
        private readonly string $title,
        private readonly string $body,
        private readonly array  $data = [],
    ) {}

    public function handle(Messaging $messaging): void
    {
        $token = $this->recipient->fcm_token;

        if (! $token) {
            return;
        }

        $message = CloudMessage::new()
            ->withToken($token)
            ->withNotification(Notification::create($this->title, $this->body))
            ->withData($this->data)
            ->withAndroidConfig(
                AndroidConfig::fromArray(['priority' => 'high']),
            );

        $messaging->send($message);
    }

    public function failed(Throwable $e): void
    {
        // Token invalide ou révoqué — on l'efface pour éviter des tentatives inutiles.
        if (str_contains($e->getMessage(), 'INVALID_ARGUMENT')
            || str_contains($e->getMessage(), 'NOT_FOUND')
        ) {
            $this->recipient->update(['fcm_token' => null]);
        }
    }
}
