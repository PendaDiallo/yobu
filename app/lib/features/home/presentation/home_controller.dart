import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../domain/home_summary.dart';

/// Le dashboard. Rien à décider ici : on lit ce que l'API a calculé.
class HomeController extends AsyncNotifier<HomeSummary> {
  @override
  Future<HomeSummary> build() => ref.read(homeRepositoryProvider).summary();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).summary(),
    );
  }
}

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomeSummary>(HomeController.new);
