import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/place.dart';
import '../domain/price_hint.dart';
import '../domain/trip.dart';
import '../domain/trip_repository.dart';
import 'trip_api.dart';

class TripRepositoryImpl implements TripRepository {
  const TripRepositoryImpl(this._api);

  final TripApi _api;

  @override
  Future<PriceHint> priceHint({
    required Place origin,
    required Place destination,
  }) async {
    try {
      return PriceHint.fromJson(await _api.priceHint(
        originLat: origin.lat,
        originLng: origin.lng,
        destLat: destination.lat,
        destLng: destination.lng,
      ));
    } catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<Trip> publish({
    required Place origin,
    required Place destination,
    required String departureTime,
    required List<int> daysOfWeek,
    required int seatsTotal,
    required int pricePerSeat,
  }) async {
    try {
      return Trip.fromJson(await _api.store({
        'origin_label': origin.label,
        'origin_lat': origin.lat,
        'origin_lng': origin.lng,
        'dest_label': destination.label,
        'dest_lat': destination.lat,
        'dest_lng': destination.lng,
        'departure_time': departureTime,
        'days_of_week': daysOfWeek,
        'seats_total': seatsTotal,
        'price_per_seat': pricePerSeat,
      }));
    } catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<List<Trip>> mine() async {
    try {
      return [
        for (final json in await _api.mine()) Trip.fromJson(json),
      ];
    } catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<Trip> setActive(int tripId, bool active) async {
    try {
      return Trip.fromJson(await _api.update(tripId, {'active': active}));
    } catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<void> delete(int tripId) async {
    try {
      await _api.delete(tripId);
    } catch (error) {
      throw _translate(error);
    }
  }

  AppException _translate(Object error) {
    if (error is AppException) return error;

    if (error is DioException) {
      // Les messages métier de l'API (validation, 403, 409) sont déjà
      // en français : on les fait suivre tels quels.
      final message = error.response?.data?['message'];
      if (message is String && message.isNotEmpty) {
        return AppException(message);
      }

      return const AppException(
        'Impossible de joindre le serveur. Vérifie ta connexion et réessaie.',
      );
    }

    return const AppException('Une erreur est survenue. Réessaie.');
  }
}
