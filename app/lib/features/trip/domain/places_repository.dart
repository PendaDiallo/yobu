import 'place.dart';

/// La recherche de lieux derrière PlaceField.
///
/// Implémentation actuelle : la liste des lieux du corridor (DETTE.md —
/// pas de clé Google). Le jour où la clé arrive, une impl Places
/// Autocomplete (country:sn + session tokens) remplace celle-ci sans
/// toucher aux écrans.
abstract interface class PlacesRepository {
  Future<List<Place>> search(String query);
}
