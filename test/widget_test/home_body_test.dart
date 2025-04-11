import 'package:bloc_test/bloc_test.dart';
import 'package:currency_exchange/src/presentation/home_page/bloc/currency_bloc.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_converted_amount.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/currency_dropdown.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/currency_grid_widget.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocking CurrencyBloc
class MockCurrencyBloc extends Mock implements CurrencyBloc {}

void main() {
  late MockCurrencyBloc mockCurrencyBloc;

  setUpAll(() {});

  setUp(() {
    mockCurrencyBloc = MockCurrencyBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<CurrencyBloc>.value(
          value: mockCurrencyBloc,
          child: const HomeBody(),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator when state is CurrencyInitial',
      (tester) async {
    when(() => mockCurrencyBloc.state).thenReturn(CurrencyInitial());
    whenListen(mockCurrencyBloc, Stream.value(CurrencyInitial()));

    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'shows error message and retry button when state is CurrencyError',
      (tester) async {
    const errorMsg = 'Failed to fetch';
    when(() => mockCurrencyBloc.state)
        .thenReturn(const CurrencyError(message: errorMsg));
    whenListen(
      mockCurrencyBloc,
      Stream.value(const CurrencyError(message: errorMsg)),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.textContaining('Error: $errorMsg'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows dropdown and list when state is CurrencyLoaded',
      (tester) async {
    const baseCurrency =
        UiCurrencyModel(code: 'USD', description: 'description', rate: 1.0);
    const rates = [
      UiCurrencyModel(code: 'USD', description: 'description', rate: 1.0),
      UiCurrencyModel(code: 'EUR', description: 'description', rate: 0.85),
    ];

    const convertedAmount = [
      UiConvertedAmount(code: 'USD', amount: 1.0),
      UiConvertedAmount(code: 'EUR', amount: 0.85),
    ];

    when(() => mockCurrencyBloc.state).thenReturn(
      const CurrencyLoaded(
        baseCurrency: baseCurrency,
        convertedAmounts: convertedAmount,
        currencyModels: rates,
      ),
    );
    whenListen(
      mockCurrencyBloc,
      Stream.value(
        const CurrencyLoaded(
          baseCurrency: baseCurrency,
          convertedAmounts: convertedAmount,
          currencyModels: rates,
        ),
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CurrencyDropdown), findsOneWidget);
    expect(find.byType(CurrencyListWidget), findsOneWidget);
  });
}
