import 'package:currency_exchange/src/core/exception/exception.dart';
import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:currency_exchange/src/domain/model/currency_rates_model.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:dio/dio.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<CurrencyRates> getCurrencyRates() async {
    try {
      final remoteRates = await remoteDataSource.getLatestUSDRates();
      localDataSource.cacheCurrencyRates(remoteRates);
      return remoteRates.toDomain();
    } on DioException catch (e) {
      // Transform specific DioErrors into domain-specific exceptions
      if (e.response?.statusCode == 404) {
        throw ServerException(message: 'User not found');
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: 'Connection timeout');
      } else {
        throw ServerException(message: 'Server error: ${e.message}');
      }
    }
  }

  @override
  Future<CurrencyRates> calculateCurrency(
    String newBaseCurrency,
    double amount,
  ) async {
    final rates = await localDataSource.getLastCurrencyRates();
    final convertedRates =
        _convertCurrencyRates(rates, newBaseCurrency, amount);
    return convertedRates.toDomain();
  }

  CurrencyRatesModel _convertCurrencyRates(
    CurrencyRatesModel rates,
    String newBaseCurrency,
    double amount,
  ) {
    // Get the conversion rate for the new base currency relative to the original base
    final newBaseRate = rates.rates[newBaseCurrency] ?? 1.0;

    final Map<String, double> convertedRates = {};

    rates.rates.forEach((currency, rate) {
      // Convert to new base currency, then multiply by amount
      convertedRates[currency] = (rate / newBaseRate) * amount;
    });

    // The new base currency itself should equal the amount
    convertedRates[newBaseCurrency] = amount;

    return CurrencyRatesModel(
      baseCurrency: newBaseCurrency,
      rates: convertedRates,
    );
  }
}
