import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/home_repository.dart';
import '../domain/home_summary.dart';
import 'home_api.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._api);

  final HomeApi _api;

  @override
  Future<HomeSummary> summary() async {
    try {
      return HomeSummary.fromJson(await _api.summary());
    } on DioException {
      throw const AppException(
        'Impossible de joindre le serveur. Vérifie ta connexion et réessaie.',
      );
    }
  }
}
