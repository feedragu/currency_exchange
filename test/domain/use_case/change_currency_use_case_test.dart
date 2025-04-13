import 'package:currency_exchange/src/domain/model/converted_amount.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:currency_exchange/src/domain/use_case/change_currency_use_case.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_converted_amount.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late ChangeCurrencyUseCase useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = ChangeCurrencyUseCase(mockRepository);
  });

  group('ChangeCurrencyUseCase', () {
    test('return converted amounts when repository call succeeds',
            () async {
          // Arrange
          const currencyCode = 'USD';
          const amount = 100.0;
          const uiCurrency = UiCurrencyModel(
            code: currencyCode,
            description: 'US Dollar',
            rate: 1,
          );

          const params = ChangeCurrencyParams(
            newBaseCurrency: uiCurrency,
            amount: amount,
          );

          final conversionAmounts = [
            const ConvertedAmount(
              code: 'EUR',
              amount: 85.23,
            ),
            const ConvertedAmount(
              code: 'GBP',
              amount: 72.45,
            ),
          ];

          when(() => mockRepository.calculateCurrency(currencyCode, amount))
              .thenAnswer((_) async => conversionAmounts);

          // Act
          final result = await useCase.run(request: params);

          // Assert
          expect(result, isA<List<UiConvertedAmount>>());
          expect(result.length, 2);
          expect(result[0].code, 'EUR');
          expect(result[0].amount, 85.23);
          expect(result[1].code, 'GBP');
          expect(result[1].amount, 72.45);

          verify(() => mockRepository.calculateCurrency(currencyCode, amount))
              .called(1);
          verifyNoMoreInteractions(mockRepository);
        });

    test('propagate exceptions from repository', () async {
      // Arrange
      const currencyCode = 'USD';
      const amount = 100.0;
      const uiCurrency = UiCurrencyModel(
        code: currencyCode,
        description: 'US Dollar',
        rate: 1,
      );

      const params = ChangeCurrencyParams(
        newBaseCurrency: uiCurrency,
        amount: amount,
      );

      when(() => mockRepository.calculateCurrency(currencyCode, amount))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
            () => useCase.run(request: params),
        throwsA(isA<Exception>()),
      );

      verify(() => mockRepository.calculateCurrency(currencyCode, amount))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('ChangeCurrencyParams equality check works correctly', () {
      // Arrange
      const currency1 = UiCurrencyModel(
        code: 'USD',
        description: 'US Dollar',
        rate: 1,
      );

      const currency2 = UiCurrencyModel(
        code: 'USD',
        description: 'US Dollar',
        rate: 1,
      );

      const currency3 = UiCurrencyModel(
        code: 'EUR',
        description: 'Euro',
        rate: 1,
      );

      // Act
      const params1 =
      ChangeCurrencyParams(newBaseCurrency: currency1, amount: 100);
      const params2 =
      ChangeCurrencyParams(newBaseCurrency: currency2, amount: 200);
      const params3 =
      ChangeCurrencyParams(newBaseCurrency: currency3, amount: 100);

      // Assert
      expect(params1, equals(params2)); // Same currency, different amount
      expect(params1, isNot(equals(params3))); // Different currency
    });
  });
}
