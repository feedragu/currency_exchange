import 'package:currency_exchange/src/domain/model/currency_rates_model.dart';

abstract class CurrencyLocalDataSource {
  Future<CurrencyRatesModel> getLastCurrencyRates();

  Future<void> cacheCurrencyRates(CurrencyRatesModel currencyRates);

  Future<bool> hasData();
}
