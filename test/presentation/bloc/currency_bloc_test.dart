import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:currency_exchange/src/domain/use_case/change_currency_use_case.dart';
import 'package:currency_exchange/src/domain/use_case/fetch_currency_rates_use_case.dart';
import 'package:currency_exchange/src/presentation/home_page/bloc/currency_bloc.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_converted_amount.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// === Mock Classes ===
class MockFetchCurrencyRatesUseCase extends Mock
    implements FetchCurrencyRatesUseCase {}

class MockChangeCurrencyUseCase extends Mock implements ChangeCurrencyUseCase {}

class FakeChangeCurrencyParams extends Fake implements ChangeCurrencyParams {}

void main() {
  late CurrencyBloc bloc;
  late MockFetchCurrencyRatesUseCase mockFetchCurrencyRatesUseCase;
  late MockChangeCurrencyUseCase mockChangeCurrencyUseCase;
  late TextEditingController currencyController;
  late TextEditingController amountController;

  const mockBaseCurrency =
      UiCurrencyModel(code: 'USD', description: 'United States Dollar', rate: 1.0);
  final mockCurrencies = [
    const UiCurrencyModel(code: 'USD', description: 'United States Dollar', rate: 1.0),
    const UiCurrencyModel(code: 'EUR', description: 'Euro', rate: 0.85),
    const UiCurrencyModel(code: 'JPY', description: 'Yen', rate: 110.0),
  ];
  final mockConvertedAmounts = [
    const UiConvertedAmount(code: 'EUR', amount: 85.0),
    const UiConvertedAmount(code: 'JPY', amount: 11000.0),
  ];
  final mockInitialAmounts = [
    const UiConvertedAmount(code: 'EUR', amount: 0.85),
    const UiConvertedAmount(code: 'JPY', amount: 110.0),
  ];

  setUpAll(() {
    registerFallbackValue(FakeChangeCurrencyParams());
  });

  setUp(() {
    mockFetchCurrencyRatesUseCase = MockFetchCurrencyRatesUseCase();
    mockChangeCurrencyUseCase = MockChangeCurrencyUseCase();
    currencyController = TextEditingController();
    amountController = TextEditingController();
    amountController.text = '100';

    bloc = CurrencyBloc(
      getCurrencyRates: mockFetchCurrencyRatesUseCase,
      changeCurrency: mockChangeCurrencyUseCase,
      currencyController: currencyController,
      amountController: amountController,
    );
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<CurrencyBloc, CurrencyState>(
    'emits [CurrencyLoading, CurrencyLoaded] when GetCurrencyRatesEvent is added',
    build: () {
      when(() => mockFetchCurrencyRatesUseCase.run()).thenAnswer(
        (_) async => UiCurrencyRate(
          baseCurrency: mockBaseCurrency,
          currencyModels: mockCurrencies,
        ),
      );
      when(() => mockChangeCurrencyUseCase.run(request: any(named: 'request')))
          .thenAnswer((_) async => mockConvertedAmounts);
      return bloc;
    },
    act: (bloc) => bloc.add(GetCurrencyRatesEvent()),
    expect: () => [
      CurrencyLoading(),
      CurrencyLoaded(
        baseCurrency: mockBaseCurrency,
        currencyModels: mockCurrencies,
        filteredCurrencyModels: mockCurrencies,
        convertedAmounts: mockConvertedAmounts,
      ),
    ],
    verify: (_) {
      expect(currencyController.text, equals('USD'));
    },
  );

  blocTest<CurrencyBloc, CurrencyState>(
    'emits updated CurrencyLoaded state when ChangeCurrencyEvent is added',
    build: () {
      when(() => mockChangeCurrencyUseCase.run(request: any(named: 'request')))
          .thenAnswer((_) async => mockConvertedAmounts);
      return bloc;
    },
    seed: () => CurrencyLoaded(
      baseCurrency: mockBaseCurrency,
      currencyModels: mockCurrencies,
      filteredCurrencyModels: mockCurrencies,
      convertedAmounts: mockConvertedAmounts,
    ),
    act: (bloc) => bloc.add(
      ChangeCurrencyEvent(
        mockCurrencies[1],
      ),
    ),
    expect: () => [
      CurrencyLoaded(
        baseCurrency: mockCurrencies[1],
        currencyModels: mockCurrencies,
        filteredCurrencyModels: mockCurrencies,
        convertedAmounts: mockConvertedAmounts
            .whereNot((currency) => currency.code == mockCurrencies[1].code)
            .toList(),
      ),
    ],
    verify: (_) {
      expect(currencyController.text, equals('EUR'));
    },
  );

  blocTest<CurrencyBloc, CurrencyState>(
    'emits updated CurrencyLoaded state when OnAmountChangedEvent is added',
    build: () {
      when(() => mockChangeCurrencyUseCase.run(request: any(named: 'request')))
          .thenAnswer((_) async => mockConvertedAmounts);
      return bloc;
    },
    seed: () => CurrencyLoaded(
      baseCurrency: mockBaseCurrency,
      currencyModels: mockCurrencies,
      filteredCurrencyModels: mockCurrencies,
      convertedAmounts: mockInitialAmounts,
    ),
    act: (bloc) => bloc.add(const OnAmountChangedEvent('10')),
    expect: () => [
      CurrencyLoaded(
        baseCurrency: mockBaseCurrency,
        currencyModels: mockCurrencies,
        filteredCurrencyModels: mockCurrencies,
        convertedAmounts: mockConvertedAmounts,
      ),
    ],
  );

  blocTest<CurrencyBloc, CurrencyState>(
    'filters currencies when FilteredItemsEvent is added',
    build: () => bloc,
    seed: () => CurrencyLoaded(
      baseCurrency: mockBaseCurrency,
      currencyModels: mockCurrencies,
      filteredCurrencyModels: mockCurrencies,
      convertedAmounts: mockConvertedAmounts,
    ),
    act: (bloc) => bloc.add(const FilteredItemsEvent('yen')),
    expect: () => [
      CurrencyLoaded(
        baseCurrency: mockBaseCurrency,
        currencyModels: mockCurrencies,
        filteredCurrencyModels: [mockCurrencies[2]],
        convertedAmounts: mockConvertedAmounts,
      ),
    ],
  );

  blocTest<CurrencyBloc, CurrencyState>(
    'emits CurrencyError when GetCurrencyRatesEvent throws',
    build: () {
      when(() => mockFetchCurrencyRatesUseCase.run())
          .thenThrow(Exception('failed'));
      return bloc;
    },
    act: (bloc) => bloc.add(GetCurrencyRatesEvent()),
    expect: () => [
      CurrencyLoading(),
      isA<CurrencyError>(),
    ],
  );
}
