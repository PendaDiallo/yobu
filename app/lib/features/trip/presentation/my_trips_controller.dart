import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../domain/trip.dart';

/// Mes trajets récurrents (conducteur). Le toggle et la suppression
/// mettent l'état à jour sur confirmation de l'API — jamais localement
/// sans elle.
class MyTripsController extends AsyncNotifier<List<Trip>> {
  @override
  Future<List<Trip>> build() => ref.read(tripRepositoryProvider).mine();

  /// Lève une AppException que l'écran affiche.
  Future<void> setActive(Trip trip, bool active) async {
    final updated =
        await ref.read(tripRepositoryProvider).setActive(trip.id, active);

    state = AsyncData([
      for (final t in state.value ?? <Trip>[]) t.id == trip.id ? updated : t,
    ]);
  }

  /// Lève une AppException (dont le 409 « trajet réservé ») que l'écran affiche.
  Future<void> delete(Trip trip) async {
    await ref.read(tripRepositoryProvider).delete(trip.id);

    state = AsyncData([
      for (final t in state.value ?? <Trip>[])
        if (t.id != trip.id) t,
    ]);
  }
}

final myTripsControllerProvider =
    AsyncNotifierProvider<MyTripsController, List<Trip>>(MyTripsController.new);
