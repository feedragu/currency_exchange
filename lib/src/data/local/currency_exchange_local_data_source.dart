import 'package:currency_exchange/src/domain/model/currency_model.dart';

abstract class CurrencyLocalDataSource {
  Future<List<CurrencyModel>> getLastCurrencyRates();

  Future<void> cacheCurrencyRates(List<CurrencyModel> currencyModels);

  Future<bool> hasData();
}
