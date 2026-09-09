import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../domain/booking.dart';

/// Mes réservations (passager). Le tri « à venir / passées » se fait sur le
/// champ `upcoming` calculé par l'API — jamais de comparaison de date ici.
class MyBookingsController extends AsyncNotifier<List<Booking>> {
  @override
  Future<List<Booking>> build() => ref.read(bookingRepositoryProvider).mine();

  /// Annuler une demande en attente ou acceptée. Lève une AppException que
  /// l'écran affiche.
  Future<void> cancel(Booking booking) async {
    final updated = await ref
        .read(bookingRepositoryProvider)
        .respond(booking.id, 'cancelled');

    state = AsyncData([
      for (final b in state.value ?? const <Booking>[])
        b.id == booking.id ? updated : b,
    ]);
  }
}

final myBookingsControllerProvider =
    AsyncNotifierProvider<MyBookingsController, List<Booking>>(
  MyBookingsController.new,
);
