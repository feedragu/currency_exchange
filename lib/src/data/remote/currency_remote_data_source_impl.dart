import 'package:currency_exchange/src/core/env_config/env_config.dart';
import 'package:currency_exchange/src/core/exception/exception.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/data/remote/model/network_currency_codes_response/network_exchange_rates_response.dart';
import 'package:currency_exchange/src/data/remote/model/network_exchange_rates_response/network_currency_codes_response.dart';
import 'package:dio/dio.dart';

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio client;
  final String apiKey;

  CurrencyRemoteDataSourceImpl({
    required this.client,
    String? apiKey,
  }) : apiKey = apiKey ?? EnvConfig.currencyApiKey;

  @override
  Future<NetworkExchangeRatesResponse> getLatestUSDRates() async {
    try {
      final response = await client.get(
        '/v6/$apiKey/latest/USD',
      );

      if (response.statusCode == 200) {
        return NetworkExchangeRatesResponse.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<NetworkCurrencyCodesResponse> getSupportedCodes() async {
    try {
      final response = await client.get(
        '/v6/$apiKey/codes',
      );

      if (response.statusCode == 200) {
        return NetworkCurrencyCodesResponse.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException();
    }
  }
}
