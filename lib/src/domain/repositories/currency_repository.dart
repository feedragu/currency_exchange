import 'package:currency_exchange/src/domain/model/currency_rates.dart';

abstract class CurrencyRepository {
  Future<CurrencyRates> getCurrencyRates();

  Future<CurrencyRates> changeCurrency(
    String newBaseCurrency,
  );
}
