import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:currency_exchange/src/domain/model/currency_rates_model.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<CurrencyRates> getCurrencyRates() async {
    final remoteRates = await remoteDataSource.getLatestUSDRates();
    localDataSource.cacheCurrencyRates(remoteRates);
    return remoteRates.toDomain();
  }

  @override
  Future<CurrencyRates> changeCurrency(
    String newBaseCurrency,
  ) async {
    final rates = await localDataSource.getLastCurrencyRates();
    final convertedRates = _convertCurrencyRates(rates, newBaseCurrency);
    return convertedRates.toDomain();
  }

  CurrencyRatesModel _convertCurrencyRates(
    CurrencyRatesModel rates,
    String newBaseCurrency,
  ) {
    // Get the conversion rate for the new base currency relative to USD
    final newBaseRate = rates.rates[newBaseCurrency] ?? 1.0;

    // Create new rates map with updated values
    final Map<String, double> convertedRates = {};

    rates.rates.forEach((currency, rate) {
      // Convert each rate to be relative to the new base currency
      convertedRates[currency] = rate / newBaseRate;
    });

    // Set the new base currency rate to 1.0
    convertedRates[newBaseCurrency] = 1.0;

    return CurrencyRatesModel(
      baseCurrency: newBaseCurrency,
      rates: convertedRates,
    );
  }
}
