import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/domain/model/currency_rates_model.dart';
import 'package:dio/dio.dart';

import '../../core/exception/exception.dart';

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio client;
  final String apiKey = 'b08d8f85620aeaedd1a47190';

  CurrencyRemoteDataSourceImpl({required this.client});

  @override
  Future<CurrencyRatesModel> getLatestUSDRates() async {
    try {
      final response = await client.get(
        '/v6/$apiKey/latest/USD',
      );

      if (response.statusCode == 200) {
        return CurrencyRatesModel.fromJson(response.data);
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
