import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../domain/booking.dart';

/// Les demandes reçues sur mes trajets (conducteur). L'acceptation passe
/// par l'API (transaction + verrou côté serveur) — jamais d'état local
/// optimiste sur une place assise.
class ReceivedRequestsController extends AsyncNotifier<List<Booking>> {
  @override
  Future<List<Booking>> build() =>
      ref.read(bookingRepositoryProvider).received();

  /// accepted | rejected. Lève une AppException (dont le « déjà complet »)
  /// que l'écran affiche.
  Future<void> respond(Booking booking, String status) async {
    final updated =
        await ref.read(bookingRepositoryProvider).respond(booking.id, status);

    if (status == 'accepted') {
      await ref
          .read(analyticsProvider)
          .logEvent(name: 'booking_accepted');
    }

    state = AsyncData([
      for (final b in state.value ?? <Booking>[])
        b.id == booking.id ? updated : b,
    ]);
  }
}

final receivedRequestsControllerProvider =
    AsyncNotifierProvider<ReceivedRequestsController, List<Booking>>(
        ReceivedRequestsController.new);
