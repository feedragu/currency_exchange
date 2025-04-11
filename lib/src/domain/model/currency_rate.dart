import 'package:currency_exchange/src/domain/model/currency_model.dart';

class CurrencyRate {
  final String baseCurrency;
  final List<CurrencyModel> currencyModels;

  const CurrencyRate({
    required this.baseCurrency,
    required this.currencyModels,
  });
}
