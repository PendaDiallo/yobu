import 'package:dio/dio.dart';

/// L'appel HTTP brut du dashboard. `GET /api/home` renvoie `{ "next": … }`
/// sans enveloppe `data`.
class HomeApi {
  const HomeApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> summary() async {
    final response = await _dio.get<Map<String, dynamic>>('/home');

    return response.data!;
  }
}
