import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/match.dart';
import '../domain/place.dart';

class SearchState {
  const SearchState({this.results, this.summary = ''});

  /// null tant qu'aucune recherche n'a été lancée.
  final AsyncValue<List<Match>>? results;

  /// Ex. « Keur Massar, Unité 15 → Plateau · avant 08:00 » — pour l'entête
  /// de search_results.
  final String summary;
}

class SearchController extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  Future<void> search({
    required Place origin,
    required Place destination,
    required String arrivalBefore,
    required String date,
  }) async {
    final summary =
        '${origin.label} → ${destination.label} · avant $arrivalBefore';
    state = SearchState(results: const AsyncLoading(), summary: summary);

    try {
      final matches = await ref.read(tripRepositoryProvider).search(
            origin: origin,
            destination: destination,
            arrivalBefore: arrivalBefore,
            date: date,
          );

      // La métrique n°1 du projet : le taux de match sort de là
      // (searches avec results_count > 0 / total des searches).
      await ref.read(analyticsProvider).logEvent(
        name: 'search_performed',
        parameters: {'results_count': matches.length},
      );

      state = SearchState(results: AsyncData(matches), summary: summary);
    } on AppException catch (exception, stackTrace) {
      state = SearchState(
        results: AsyncError(exception, stackTrace),
        summary: summary,
      );
    }
  }
}

final searchControllerProvider =
    NotifierProvider<SearchController, SearchState>(SearchController.new);
