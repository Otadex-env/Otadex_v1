/// Tarifs des plans OTADEX — source UNIQUE.
///
/// Toujours affichés en FCFA (XAF), jamais convertis dans une autre devise :
/// contrainte de soumission Play Store (pas de tarif tiers ambigu) + lisibilité
/// pour le marché cible.
class PlanPrices {
  PlanPrices._();

  static const int joninMonthlyXaf = 2000;
  static const int joninAnnualXaf = 21600; // 2 000 × 12 × 0,9 (−10 %)
  static const int kageMonthlyXaf = 5000;
  static const int kageAnnualXaf = 54000; // 5 000 × 12 × 0,9 (−10 %)

  /// Plan gratuit.
  static const String free = '0 FCFA';

  static String jonin({bool annual = false}) =>
      _line(annual ? joninAnnualXaf : joninMonthlyXaf, annual: annual);

  static String kage({bool annual = false}) =>
      _line(annual ? kageAnnualXaf : kageMonthlyXaf, annual: annual);

  /// Montant seul (« 2 000 FCFA »), sans période — pour les UI qui affichent
  /// la période dans un libellé séparé (ex. `SubscriptionBillingCard`).
  static String joninAmount({bool annual = false}) =>
      '${_grouped(annual ? joninAnnualXaf : joninMonthlyXaf)} FCFA';

  static String kageAmount({bool annual = false}) =>
      '${_grouped(annual ? kageAnnualXaf : kageMonthlyXaf)} FCFA';

  static String _line(int xaf, {required bool annual}) =>
      '${_grouped(xaf)} FCFA${annual ? ' / an' : ' / mois'}';

  /// Séparateur de milliers (espace) : `21600` → `"21 600"`.
  static String _grouped(int amount) {
    final raw = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(raw[i]);
    }
    return buffer.toString();
  }
}
