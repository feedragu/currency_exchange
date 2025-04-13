import 'package:currency_exchange/src/core/exception/exception.dart';
import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/data/remote/model/network_currency_codes_response/network_exchange_rates_response.dart';
import 'package:currency_exchange/src/data/remote/model/network_exchange_rates_response/network_currency_codes_response.dart';
import 'package:currency_exchange/src/data/repositories/currency_repository_impl.dart';
import 'package:currency_exchange/src/domain/model/currency_code.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../constants/constants.dart';

class MockRemoteDataSource extends Mock implements CurrencyRemoteDataSource {}

class MockLocalDataSource extends Mock implements CurrencyLocalDataSource {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late CurrencyRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = CurrencyRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('getCurrencyRates', () {
    test('returns CurrencyRates when remote call is successful', () async {
      when(() => mockRemote.getLatestUSDRates()).thenAnswer(
        (_) async => NetworkExchangeRatesResponse.fromJson(
          mockResponse,
        ),
      );

      final result = await repository.getCurrencyRates();

      expect(result, isA<CurrencyRates>());
      expect(result.baseCurrency, equals('USD'));
      verify(() => mockRemote.getLatestUSDRates()).called(1);
    });

    test('throws ServerException on 404', () async {
      when(() => mockRemote.getLatestUSDRates()).thenThrow(
        DioException(
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => repository.getCurrencyRates(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getExchangeCodes', () {
    test('returns list of CurrencyCode on success', () async {
      when(() => mockRemote.getSupportedCodes()).thenAnswer(
        (_) async => NetworkCurrencyCodesResponse.fromJson(
          mockCodesResponse,
        ),
      );

      final result = await repository.getExchangeCodes();

      expect(result, isA<List<CurrencyCode>>());
      expect(result.first.code, equals('USD'));
      verify(() => mockRemote.getSupportedCodes()).called(1);
    });
  });

  group('calculateCurrency', () {
    test('returns converted amounts from local cache', () async {
      final rates = [
        const CurrencyModel(code: 'USD', rate: 1.0, description: ''),
        const CurrencyModel(code: 'EUR', rate: 0.85, description: ''),
      ];

      when(() => mockLocal.getLastCurrencyRates())
          .thenAnswer((_) async => rates);

      final result = await repository.calculateCurrency('USD', 100);

      expect(result.length, equals(2));
      expect(result.firstWhere((e) => e.code == 'USD').amount, equals(100));
      expect(
        result.firstWhere((e) => e.code == 'EUR').amount,
        closeTo(85.0, 0.01),
      );
    });

    test('throws CacheException when no rates are cached', () async {
      when(() => mockLocal.getLastCurrencyRates()).thenAnswer((_) async => []);

      expect(
        () => repository.calculateCurrency('USD', 100),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
