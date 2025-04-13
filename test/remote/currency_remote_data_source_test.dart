import 'package:currency_exchange/src/core/exception/exception.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source_impl.dart';
import 'package:currency_exchange/src/data/remote/model/network_currency_codes_response/network_exchange_rates_response.dart';
import 'package:currency_exchange/src/data/remote/model/network_exchange_rates_response/network_currency_codes_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../constants/constants.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late CurrencyRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  const String mockApiKey = 'test_api_key';

  setUp(() {
    mockDio = MockDio();
    dataSource = CurrencyRemoteDataSourceImpl(
      client: mockDio,
      apiKey: mockApiKey,
    );
  });

  group('getLatestUSDRates', () {
    test('return NetworkExchangeRatesResponse when the call is successful',
        () async {
      when(() => mockDio.get('/v6/$mockApiKey/latest/USD')).thenAnswer(
        (_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getLatestUSDRates();

      expect(result, isA<NetworkExchangeRatesResponse>());
      expect(result.baseCurrency, 'USD');
      expect(result.conversionRates?['EUR'], 0.84);
      verify(() => mockDio.get('/v6/$mockApiKey/latest/USD')).called(1);
    });

    test('throw ServerException when the response code is not 200', () async {
      when(() => mockDio.get('/v6/$mockApiKey/latest/USD')).thenAnswer(
        (_) async => Response(
          data: {'error': 'Something went wrong'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await expectLater(
        dataSource.getLatestUSDRates(),
        throwsA(
          predicate((dynamic e) => e is ServerException),
        ),
      );
      verify(() => mockDio.get('/v6/$mockApiKey/latest/USD')).called(1);
    });

    test('throw ServerException when DioException occurs', () async {
      when(() => mockDio.get('/v6/$mockApiKey/latest/USD')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
          message: 'Server error',
        ),
      );

      await expectLater(
        dataSource.getLatestUSDRates(),
        throwsA(
          predicate(
            (dynamic e) => e is ServerException,
          ),
        ),
      );
      verify(() => mockDio.get('/v6/$mockApiKey/latest/USD')).called(1);
    });

    test('throw ServerException when unexpected error occurs', () async {
      when(() => mockDio.get('/v6/$mockApiKey/latest/USD'))
          .thenThrow(Exception('Unexpected error'));

      await expectLater(
        dataSource.getLatestUSDRates(),
        throwsA(
          predicate(
            (dynamic e) => e is ServerException,
          ),
        ),
      );
      verify(() => mockDio.get('/v6/$mockApiKey/latest/USD')).called(1);
    });
  });

  group('getSupportedCodes', () {
    test('return NetworkCurrencyCodesResponse when the call is successful',
        () async {
      when(() => mockDio.get('/v6/$mockApiKey/codes')).thenAnswer(
        (_) async => Response(
          data: mockCodesResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getSupportedCodes();

      expect(result, isA<NetworkCurrencyCodesResponse>());
      expect(result.supportedCodes?.length, 4);
      expect(result.supportedCodes?[0][0], 'USD');
      expect(result.supportedCodes?[0][1], 'United States Dollar');
      verify(() => mockDio.get('/v6/$mockApiKey/codes')).called(1);
    });

    test('throw ServerException when the response code is not 200', () async {
      when(() => mockDio.get('/v6/$mockApiKey/codes')).thenAnswer(
        (_) async => Response(
          data: {'error': 'Something went wrong'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await expectLater(
        dataSource.getSupportedCodes(),
        throwsA(
          predicate(
            (dynamic e) => e is ServerException,
          ),
        ),
      );
      verify(() => mockDio.get('/v6/$mockApiKey/codes')).called(1);
    });

    test('throw ServerException when DioException occurs', () async {
      when(() => mockDio.get('/v6/$mockApiKey/codes')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
          message: 'Not found',
        ),
      );

      await expectLater(
        dataSource.getSupportedCodes(),
        throwsA(
          predicate((dynamic e) => e is ServerException),
        ),
      );
      verify(() => mockDio.get('/v6/$mockApiKey/codes')).called(1);
    });

    test('throw ServerException when unexpected error occurs', () async {
      when(() => mockDio.get('/v6/$mockApiKey/codes'))
          .thenThrow(Exception('Unexpected error'));

      await expectLater(
        dataSource.getSupportedCodes(),
        throwsA(
          predicate(
            (dynamic e) => e is ServerException,
          ),
        ),
      );
      verify(() => mockDio.get('/v6/$mockApiKey/codes')).called(1);
    });
  });
}
