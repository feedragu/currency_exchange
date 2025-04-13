import 'package:currency_exchange/src/core/exception/cache_exception.dart';
import 'package:currency_exchange/src/domain/model/currency_code.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:currency_exchange/src/domain/use_case/fetch_currency_rates_use_case.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_rate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late FetchCurrencyRatesUseCase useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = FetchCurrencyRatesUseCase(mockRepository);
  });

  final testCurrencyRates = CurrencyRates(
    baseCurrency: 'USD',
    rates: {
      'USD': 1.0,
      'EUR': 0.85,
      'GBP': 0.75,
      'JPY': 110.0,
    },
  );

  final testCurrencyCodes = [
    CurrencyCode(code: 'USD', description: 'United States Dollar'),
    CurrencyCode(code: 'EUR', description: 'Euro'),
    CurrencyCode(code: 'GBP', description: 'British Pound'),
    CurrencyCode(code: 'JPY', description: 'Japanese Yen'),
  ];

  final expectedCurrencyModels = [
    const CurrencyModel(
      code: 'USD',
      description: 'United States Dollar',
      rate: 1.0,
    ),
    const CurrencyModel(code: 'EUR', description: 'Euro', rate: 0.85),
    const CurrencyModel(code: 'GBP', description: 'British Pound', rate: 0.75),
    const CurrencyModel(code: 'JPY', description: 'Japanese Yen', rate: 110.0),
  ];

  group('FetchCurrencyRatesUseCase', () {
    test(
        'should return UiCurrencyRate with USD as base currency when fetch is successful',
        () async {
      // Arrange
      when(() => mockRepository.getCurrencyRates())
          .thenAnswer((_) async => testCurrencyRates);
      when(() => mockRepository.getExchangeCodes())
          .thenAnswer((_) async => testCurrencyCodes);
      when(() => mockRepository.cacheCurrencyRates(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.run();

      // Assert
      expect(result, isA<UiCurrencyRate>());
      expect(result.baseCurrency.code, 'USD');
      expect(result.currencyModels.length, 4);
      verify(() => mockRepository.getCurrencyRates()).called(1);
      verify(() => mockRepository.getExchangeCodes()).called(1);
      verify(() => mockRepository.cacheCurrencyRates(any())).called(1);
    });

    test('should handle currency codes with missing descriptions', () async {
      // Arrange
      when(() => mockRepository.getCurrencyRates()).thenAnswer(
        (_) async => CurrencyRates(
          baseCurrency: 'USD',
          rates: {
            'USD': 1.0,
            'EUR': 0.85,
            'XYZ': 2.0, // Currency with no matching code
          },
        ),
      );
      when(() => mockRepository.getExchangeCodes())
          .thenAnswer((_) async => testCurrencyCodes);
      when(() => mockRepository.cacheCurrencyRates(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.run();

      // Assert
      expect(result, isA<UiCurrencyRate>());
      expect(result.baseCurrency.code, 'USD');
      expect(result.currencyModels.length, 3);
      final xyzCurrency = result.currencyModels.firstWhere(
        (currency) => currency.code == 'XYZ',
        orElse: () => const UiCurrencyModel(code: '', description: '', rate: 0),
      );
      expect(xyzCurrency.code, 'XYZ');
      expect(xyzCurrency.description, ''); // Empty description
    });

    test('should use cached data when fetch fails', () async {
      // Arrange
      when(() => mockRepository.getCurrencyRates())
          .thenThrow(Exception('Network error'));
      when(() => mockRepository.getExchangeCodes())
          .thenThrow(Exception('Network error'));
      when(() => mockRepository.getCachedCurrencyRates())
          .thenAnswer((_) async => expectedCurrencyModels);

      // Act
      final result = await useCase.run();

      // Assert
      expect(result, isA<UiCurrencyRate>());
      expect(result.baseCurrency.code, 'USD');
      expect(result.currencyModels.length, 4);
      verify(() => mockRepository.getCachedCurrencyRates()).called(1);
      verifyNever(() => mockRepository.cacheCurrencyRates(any()));
    });

    test('should throw CacheException when both fetch and cache fail',
        () async {
      // Arrange
      when(() => mockRepository.getCurrencyRates())
          .thenThrow(Exception('Network error'));
      when(() => mockRepository.getExchangeCodes())
          .thenThrow(Exception('Network error'));
      when(() => mockRepository.getCachedCurrencyRates())
          .thenAnswer((_) async => []);

      // Act & Assert
      expect(() => useCase.run(), throwsA(isA<CacheException>()));
    });

    test('should choose different base currency when USD is not available',
        () async {
      // Arrange
      final nonUsdRates = CurrencyRates(
        baseCurrency: 'EUR', // Base currency is not USD
        rates: {
          'EUR': 1.0,
          'GBP': 0.88,
          'JPY': 130.0,
        },
      );

      when(() => mockRepository.getCurrencyRates())
          .thenAnswer((_) async => nonUsdRates);
      when(() => mockRepository.getExchangeCodes()).thenAnswer(
        (_) async => testCurrencyCodes
            .where(
              (code) => code.code != 'USD',
            )
            .toList(),
      );
      when(() => mockRepository.cacheCurrencyRates(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.run();

      // Assert
      expect(result, isA<UiCurrencyRate>());
      expect(result.baseCurrency.code, 'EUR');
      expect(result.currencyModels.length, 3);
    });

    test(
        'should fallback to first currency when specified base currency not found',
        () async {
      // Arrange
      final testRates = CurrencyRates(
        baseCurrency: 'XYZ', // Currency that doesn't exist in the list
        rates: {
          'EUR': 1.0,
          'GBP': 0.88,
        },
      );

      when(() => mockRepository.getCurrencyRates())
          .thenAnswer((_) async => testRates);
      when(() => mockRepository.getExchangeCodes()).thenAnswer(
        (_) async => [
          CurrencyCode(code: 'EUR', description: 'Euro'),
          CurrencyCode(code: 'GBP', description: 'British Pound'),
        ],
      );
      when(() => mockRepository.cacheCurrencyRates(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.run();

      // Assert
      expect(result, isA<UiCurrencyRate>());
      expect(result.baseCurrency.code, 'EUR'); // Falls back to first currency
      expect(result.currencyModels.length, 2);
    });
  });
}
