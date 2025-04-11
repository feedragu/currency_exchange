import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/data/remote/model/network_currency_codes_response/network_exchange_rates_response.dart';
import 'package:currency_exchange/src/data/remote/model/network_exchange_rates_response/network_currency_codes_response.dart';
import 'package:dio/dio.dart';

import '../../core/exception/exception.dart';

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio client;
  final String apiKey = 'b08d8f85620aeaedd1a47190';

  CurrencyRemoteDataSourceImpl({required this.client});

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
          message: 'Failed to load currency rates',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
      );
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
          message: 'Failed to load currency rates',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }
}
