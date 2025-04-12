import 'package:currency_exchange/src/domain/model/converted_amount.dart';
import 'package:currency_exchange/src/domain/model/currency_code.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';

abstract class CurrencyRepository {
  Future<CurrencyRates> getCurrencyRates();

  Future<List<CurrencyCode>> getExchangeCodes();

  Future<List<ConvertedAmount>> calculateCurrency(
    String newBaseCurrency,
    double amount,
  );

  Future<void> cacheCurrencyRates(List<CurrencyModel> currencyModels);

  Future<List<CurrencyModel>> getCachedCurrencyRates();
}
