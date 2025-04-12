import 'package:collection/collection.dart';
import 'package:currency_exchange/src/core/exception/exception.dart';
import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/data/repositories/extension/exchange_codes_ext.dart';
import 'package:currency_exchange/src/data/repositories/extension/exchange_currency_ext.dart';
import 'package:currency_exchange/src/domain/model/converted_amount.dart';
import 'package:currency_exchange/src/domain/model/currency_code.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
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
      final currencyRates = remoteRates.toCurrencyRatesDomain();
      if (currencyRates != null) {
        return currencyRates;
      } else {
        throw ServerException(message: 'Server error');
      }
    } on DioException catch (e) {
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
  Future<List<CurrencyCode>> getExchangeCodes() async {
    try {
      final remoteRates = await remoteDataSource.getSupportedCodes();
      final currencyRates = remoteRates.toCurrencyCodeDomain();
      return currencyRates;
    } on DioException catch (e) {
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
  Future<List<ConvertedAmount>> calculateCurrency(
    String newBaseCurrency,
    double amount,
  ) async {
    final rates = await localDataSource.getLastCurrencyRates();
    final convertedRates =
        _convertCurrencyRates(rates, newBaseCurrency, amount);
    return convertedRates;
  }

  List<ConvertedAmount> _convertCurrencyRates(
    List<CurrencyModel> rates,
    String newBaseCurrency,
    double amount,
  ) {
    if (rates.isNotEmpty) {
      // Get the conversion rate for the new base currency relative to the original base
      final newBaseRate = rates
              .firstWhereOrNull(
                (currencyModel) => currencyModel.code == newBaseCurrency,
              )
              ?.rate ??
          1.0;

      final List<ConvertedAmount> convertedAmount = rates
          .map(
            (currencyModel) => ConvertedAmount(
              code: currencyModel.code,
              amount: (currencyModel.rate / newBaseRate) * amount,
            ),
          )
          .toList();

      return convertedAmount;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCurrencyRates(List<CurrencyModel> currencyModels) =>
      localDataSource.cacheCurrencyRates(currencyModels);

  @override
  Future<List<CurrencyModel>> getCachedCurrencyRates() =>
      localDataSource.getLastCurrencyRates();
}
