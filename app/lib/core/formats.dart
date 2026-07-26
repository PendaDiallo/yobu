/// Mise en forme d'affichage — jamais de calcul métier ici.
library;

const _weekdays = ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.', 'dim.'];
const _months = [
  'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
  'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
];

/// « 2026-08-03 » → « lun. 3 août ».
String formatDateShort(String isoDate) {
  final date = DateTime.parse(isoDate);

  return '${_weekdays[date.weekday - 1]} ${date.day} ${_months[date.month - 1]}';
}

/// 1200 → « 1 200 F ».
String formatPrice(int price) {
  final grouped = price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (match) => '${match[1]} ',
      );

  return '$grouped F';
}
