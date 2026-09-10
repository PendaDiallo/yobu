import 'package:dio/dio.dart';

/// L'appel HTTP brut de la notation. Rien d'autre.
class RatingApi {
  const RatingApi(this._dio);

  final Dio _dio;

  Future<void> create({
    required int bookingId,
    required int score,
    required List<String> tags,
    String? comment,
  }) async {
    await _dio.post<Map<String, dynamic>>('/ratings', data: {
      'booking_id': bookingId,
      'score': score,
      'tags': tags,
      'comment': ?comment,
    });
  }
}
