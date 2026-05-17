class PlanPrices {
  PlanPrices._();

  static const int joninMonthlyXaf = 2000;
  static const int joninAnnualXaf = 20000;
  static const int kageMonthlyXaf = 5000;
  static const int kageAnnualXaf = 54000;

  static String jonin(bool annual, String currency) {
    return format(
      annual ? joninAnnualXaf : joninMonthlyXaf,
      currency,
      annual: annual,
    );
  }

  static String kage(bool annual, String currency) {
    return format(
      annual ? kageAnnualXaf : kageMonthlyXaf,
      currency,
      annual: annual,
    );
  }

  static String free(String currency) => format(0, currency);

  static String format(int xafAmount, String currency, {bool annual = false}) {
    final normalized = _normalize(currency);
    final suffix = annual ? ' / an' : (xafAmount == 0 ? '' : ' / mois');
    if (normalized == 'XAF') {
      return '${_whole(xafAmount)} FCFA$suffix';
    }

    final rate = _rates[normalized] ?? _rates['USD']!;
    final amount = xafAmount * rate;
    final value = xafAmount == 0 ? '0' : amount.toStringAsFixed(2);
    return '${_symbols[normalized] ?? normalized} $value$suffix';
  }

  static String _normalize(String currency) => currency.toUpperCase().trim();

  static String _whole(int amount) {
    final raw = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      final remaining = raw.length - i;
      buffer.write(raw[i]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  static const Map<String, double> _rates = {
    'XAF': 1,
    'USD': 1 / 600,
    'EUR': 1 / 655,
    'GBP': 1 / 765,
    'CAD': 1 / 440,
    'NGN': 2.55,
  };

  static const Map<String, String> _symbols = {
    'USD': r'$',
    'EUR': 'EUR',
    'GBP': 'GBP',
    'CAD': r'CA$',
    'NGN': 'NGN',
  };
}
