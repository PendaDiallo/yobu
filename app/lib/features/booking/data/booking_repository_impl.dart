import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/booking.dart';
import '../domain/booking_repository.dart';
import 'booking_api.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this._api);

  final BookingApi _api;

  @override
  Future<Booking> request({required int tripId, required String date}) async {
    try {
      return Booking.fromJson(await _api.store(tripId, date));
    } catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<List<Booking>> mine() async {
    try {
      return [for (final json in await _api.mine()) Booking.fromJson(json)];
    } catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<List<Booking>> received() async {
    try {
      return [
        for (final json in await _api.received()) Booking.fromJson(json),
      ];
    } catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<Booking> respond(int bookingId, String status) async {
    try {
      return Booking.fromJson(await _api.update(bookingId, status));
    } catch (error) {
      throw _translate(error);
    }
  }

  AppException _translate(Object error) {
    if (error is AppException) return error;

    if (error is DioException) {
      final data = error.response?.data;
      // La première erreur de validation est déjà en français.
      if (data is Map && data['errors'] is Map) {
        final first = (data['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) {
          return AppException('${first.first}');
        }
      }
      final message = data is Map ? data['message'] : null;
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
