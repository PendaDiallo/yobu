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
      throw AppException.fromDio(error);
    }
  }

  @override
  Future<List<Booking>> mine() async {
    try {
      return [for (final json in await _api.mine()) Booking.fromJson(json)];
    } catch (error) {
      throw AppException.fromDio(error);
    }
  }

  @override
  Future<List<Booking>> received() async {
    try {
      return [
        for (final json in await _api.received()) Booking.fromJson(json),
      ];
    } catch (error) {
      throw AppException.fromDio(error);
    }
  }

  @override
  Future<Booking> respond(int bookingId, String status) async {
    try {
      return Booking.fromJson(await _api.update(bookingId, status));
    } catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
