class CurrencyRates {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime? lastUpdated;

  CurrencyRates({
    required this.baseCurrency,
    required this.rates,
    this.lastUpdated,
  });
}
