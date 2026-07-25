import 'package:dio/dio.dart';

/// Les appels HTTP bruts des trajets. Rien d'autre.
class TripApi {
  const TripApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> priceHint({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/trips/price-hint',
      queryParameters: {
        'origin': '$originLat,$originLng',
        'destination': '$destLat,$destLng',
      },
    );

    return response.data!;
  }

  Future<List<Map<String, dynamic>>> search(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/trips/search', data: body);

    return (response.data!['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> store(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/trips', data: body);

    return response.data!['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> mine() async {
    final response = await _dio.get<Map<String, dynamic>>('/trips/mine');

    return (response.data!['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> update(int tripId, Map<String, dynamic> body) async {
    final response =
        await _dio.patch<Map<String, dynamic>>('/trips/$tripId', data: body);

    return response.data!['data'] as Map<String, dynamic>;
  }

  Future<void> delete(int tripId) => _dio.delete('/trips/$tripId');
}
