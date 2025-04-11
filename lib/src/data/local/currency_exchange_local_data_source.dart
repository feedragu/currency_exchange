import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:currency_exchange/src/domain/model/currency_rates_model.dart';

abstract class CurrencyLocalDataSource {
  Future<CurrencyRatesModel> getLastCurrencyRates();

  Future<void> cacheCurrencyRates(CurrencyRates currencyRates);

  Future<bool> hasData();
}
