import 'package:dio/dio.dart';

/// Les appels HTTP bruts des réservations. Rien d'autre.
class BookingApi {
  const BookingApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> store(int tripId, String date) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/bookings',
      data: {'trip_id': tripId, 'date': date},
    );

    return response.data!['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> mine() async {
    final response = await _dio.get<Map<String, dynamic>>('/bookings');

    return (response.data!['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> received() async {
    final response =
        await _dio.get<Map<String, dynamic>>('/bookings/received');

    return (response.data!['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> update(int bookingId, String status) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/bookings/$bookingId',
      data: {'status': status},
    );

    return response.data!['data'] as Map<String, dynamic>;
  }
}
