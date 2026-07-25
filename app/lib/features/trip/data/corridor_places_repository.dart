import '../domain/place.dart';
import '../domain/places_repository.dart';

/// Les lieux du corridor Keur Massar → Plateau, en dur, avec de vraies
/// coordonnées de la zone.
///
/// C'est le repli documenté de DETTE.md : pas de clé Google tant que la
/// facturation n'est pas activée. Suffit pour la zone de lancement — et
/// l'interface PlacesRepository absorbera Places Autocomplete sans toucher
/// aux écrans.
class CorridorPlacesRepository implements PlacesRepository {
  const CorridorPlacesRepository();

  static const _places = [
    // Côté Keur Massar
    Place(label: 'Keur Massar, Unité 15', lat: 14.7876, lng: -17.3138),
    Place(label: 'Keur Massar, Marché', lat: 14.7847, lng: -17.3167),
    Place(label: 'Keur Massar, Boune', lat: 14.7833, lng: -17.3194),
    Place(label: 'Keur Massar, Aïnoumady', lat: 14.7793, lng: -17.3092),
    Place(label: 'Keur Massar, Cité Sotrac', lat: 14.7909, lng: -17.3252),
    Place(label: 'Keur Massar, Darou Missette', lat: 14.7754, lng: -17.3199),
    Place(label: 'Keur Massar, Rond-point', lat: 14.7865, lng: -17.3211),
    // Sur la route
    Place(label: 'Pikine, Tally Boubess', lat: 14.7550, lng: -17.3910),
    Place(label: 'Patte d\'Oie, Échangeur', lat: 14.7457, lng: -17.4308),
    Place(label: 'Hann, Route des Pères Maristes', lat: 14.7220, lng: -17.4300),
    // Côté Plateau
    Place(label: 'Plateau, Place de l\'Indépendance', lat: 14.6673, lng: -17.4344),
    Place(label: 'Plateau, Sandaga', lat: 14.6717, lng: -17.4395),
    Place(label: 'Plateau, Avenue Léopold Sédar Senghor', lat: 14.6669, lng: -17.4381),
    Place(label: 'Plateau, Terminus Petersen', lat: 14.6743, lng: -17.4437),
    Place(label: 'Plateau, Ponty', lat: 14.6690, lng: -17.4370),
  ];

  @override
  Future<List<Place>> search(String query) async {
    final needle = _normalize(query);
    if (needle.isEmpty) return _places;

    return [
      for (final place in _places)
        if (_normalize(place.label).contains(needle)) place,
    ];
  }

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp('[àâä]'), 'a')
      .replaceAll(RegExp('[éèêë]'), 'e')
      .replaceAll(RegExp('[îï]'), 'i')
      .replaceAll(RegExp('[ôö]'), 'o')
      .replaceAll(RegExp('[ûüù]'), 'u')
      .trim();
}
