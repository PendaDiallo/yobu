import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../domain/place.dart';
import '../domain/price_hint.dart';
import 'my_trips_controller.dart';

class TripCreateState {
  const TripCreateState({this.hint, this.publishing = false});

  /// La fourchette de l'API pour la paire de lieux choisie.
  final PriceHint? hint;
  final bool publishing;
}

class TripCreateController extends Notifier<TripCreateState> {
  @override
  TripCreateState build() => const TripCreateState();

  /// Charge la fourchette dès que les deux lieux sont connus. Best effort :
  /// si l'API échoue, on publie quand même sans fourchette.
  Future<void> loadHint(Place origin, Place destination) async {
    try {
      final hint = await ref
          .read(tripRepositoryProvider)
          .priceHint(origin: origin, destination: destination);
      state = TripCreateState(hint: hint, publishing: state.publishing);
    } catch (_) {
      state = TripCreateState(hint: null, publishing: state.publishing);
    }
  }

  /// Publie le trajet. Lève une AppException que l'écran affiche.
  Future<void> publish({
    required Place origin,
    required Place destination,
    required String departureTime,
    required List<int> daysOfWeek,
    required int seatsTotal,
    required int pricePerSeat,
  }) async {
    state = TripCreateState(hint: state.hint, publishing: true);
    try {
      await ref.read(tripRepositoryProvider).publish(
            origin: origin,
            destination: destination,
            departureTime: departureTime,
            daysOfWeek: daysOfWeek,
            seatsTotal: seatsTotal,
            pricePerSeat: pricePerSeat,
          );

      await ref
          .read(analyticsProvider)
          .logEvent(name: 'trip_published', parameters: {
        'price_per_seat': pricePerSeat,
        'seats_total': seatsTotal,
      });

      ref.invalidate(myTripsControllerProvider);
    } finally {
      state = TripCreateState(hint: state.hint, publishing: false);
    }
  }
}

final tripCreateControllerProvider =
    NotifierProvider<TripCreateController, TripCreateState>(
        TripCreateController.new);
