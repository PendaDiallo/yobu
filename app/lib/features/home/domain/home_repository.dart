import 'home_summary.dart';

/// Le contrat du dashboard. Erreurs en AppException.
abstract interface class HomeRepository {
  Future<HomeSummary> summary();
}
