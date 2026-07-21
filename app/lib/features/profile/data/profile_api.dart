import 'package:dio/dio.dart';

/// Les appels HTTP bruts du profil. Rien d'autre.
class ProfileApi {
  const ProfileApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/me');

    return response.data!['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMe(Map<String, dynamic> body) async {
    final response = await _dio.patch<Map<String, dynamic>>('/me', data: body);

    return response.data!['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> uploadPhoto(String filePath) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/me/photo',
      data: FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      }),
    );

    return response.data!['data'] as Map<String, dynamic>;
  }
}
