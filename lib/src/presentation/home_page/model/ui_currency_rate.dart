import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';

class UiCurrencyRate {
  final UiCurrencyModel baseCurrency;
  final List<UiCurrencyModel> currencyModels;

  const UiCurrencyRate({
    required this.baseCurrency,
    required this.currencyModels,
  });
}
