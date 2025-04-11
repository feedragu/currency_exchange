import 'package:currency_exchange/src/domain/model/currency_rates.dart';

class CurrencyRatesModel {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime? lastUpdated;

  CurrencyRatesModel({
    required this.baseCurrency,
    required this.rates,
    this.lastUpdated,
  });

  factory CurrencyRatesModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> ratesJson = json['conversion_rates'] ?? {};
    final Map<String, double> rates = {};

    ratesJson.forEach((key, value) {
      rates[key] = (value is int) ? value.toDouble() : value;
    });

    return CurrencyRatesModel(
      baseCurrency: json['base_code'] ?? 'USD',
      rates: rates,
      lastUpdated: DateTime.now(),
    );
  }

  factory CurrencyRatesModel.fromEntity(CurrencyRates entity) {
    return CurrencyRatesModel(
      baseCurrency: entity.baseCurrency,
      rates: entity.rates,
      lastUpdated: entity.lastUpdated,
    );
  }

  CurrencyRates toDomain() {
    return CurrencyRates(
      baseCurrency: baseCurrency,
      rates: rates,
      lastUpdated: lastUpdated,
    );
  }
}
