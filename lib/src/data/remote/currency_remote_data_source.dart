import 'package:currency_exchange/src/data/remote/model/network_currency_codes_response/network_exchange_rates_response.dart';
import 'package:currency_exchange/src/data/remote/model/network_exchange_rates_response/network_currency_codes_response.dart';
import 'package:currency_exchange/src/domain/model/currency_rates_model.dart';

abstract class CurrencyRemoteDataSource {
  /// Fetches the latest exchange rates with USD as the base currency
  ///
  /// Returns a [CurrencyRatesModel] with exchange rates if successful
  /// Throws a [ServerException] if there's a problem with the server
  Future<NetworkExchangeRatesResponse> getLatestUSDRates();

  /// Fetches the latest exchange rates with USD as the base currency
  ///
  /// Returns a [CurrencyRatesModel] with exchange rates if successful
  /// Throws a [ServerException] if there's a problem with the server
  Future<NetworkCurrencyCodesResponse> getSupportedCodes();
}
