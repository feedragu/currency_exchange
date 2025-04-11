import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:currency_exchange/src/domain/usecases/model/app_use_case.dart';

/// Use case to fetch the latest exchange rates from USD
class FetchCurrencyRatesUseCase implements AppUseCase<Future<CurrencyRates>> {
  final CurrencyRepository repository;

  FetchCurrencyRatesUseCase(this.repository);

  @override
  Future<CurrencyRates> run() async {
    final results = await Future.wait([
      repository.getCurrencyRates(),
      repository.getExchangeCodes(),
    ]);

    final rates = results[0] as CurrencyRates;
    final codes = results[1] as List<CurrencyCode>;

    return rates;
  }
}
