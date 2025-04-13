import 'package:currency_exchange/src/core/design_system/app_text_field.dart';
import 'package:currency_exchange/src/core/localizations/l10n/gen/app_localizations.g.dart';
import 'package:currency_exchange/src/presentation/home_page/bloc/currency_bloc.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_converted_amount.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/currency_dropdown.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/currency_grid_widget.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock classes
@GenerateMocks([CurrencyBloc, AppLocalizations])
import 'home_body_test.mocks.dart';

// Mock AppLocalizationProvider to return our mock localizations
class TestAppLocalizationProvider extends StatelessWidget {
  final Widget child;
  final AppLocalizations localizations;

  const TestAppLocalizationProvider({
    super.key,
    required this.child,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return _LocalizationsInheritedWidget(
      localizations: localizations,
      child: child,
    );
  }
}

class _LocalizationsInheritedWidget extends InheritedWidget {
  final AppLocalizations localizations;

  const _LocalizationsInheritedWidget({
    required this.localizations,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LocalizationsInheritedWidget oldWidget) {
    return localizations != oldWidget.localizations;
  }

  static _LocalizationsInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LocalizationsInheritedWidget>();
  }
}

// Patch the AppLocalizationProvider to use our test implementation
class AppLocalizationProvider {
  static AppLocalizations of(BuildContext context) {
    final wrapper = _LocalizationsInheritedWidget.of(context);
    if (wrapper != null) {
      return wrapper.localizations;
    }
    throw Exception('No localizations found in context');
  }
}

void main() {
  late MockCurrencyBloc mockCurrencyBloc;
  late TextEditingController mockAmountController;
  late TextEditingController mockCurrencyController;
  late MockAppLocalizations mockLocalizations;
  provideDummy<CurrencyState>(
    CurrencyInitial(),
  );

  setUp(() {
    mockCurrencyBloc = MockCurrencyBloc();
    mockAmountController = TextEditingController();
    mockCurrencyController = TextEditingController();
    mockLocalizations = MockAppLocalizations();

    // Setup the bloc's controllers
    when(mockCurrencyBloc.amountController).thenReturn(mockAmountController);
    when(mockCurrencyBloc.currencyController)
        .thenReturn(mockCurrencyController);

    // Setup localizations
    when(mockLocalizations.amount).thenReturn('Amount');
    when(mockLocalizations.retry).thenReturn('Retry');
  });

  tearDown(() {
    mockAmountController.dispose();
    mockCurrencyController.dispose();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      home: Scaffold(
        body: BlocProvider<CurrencyBloc>.value(
          value: mockCurrencyBloc,
          child: const HomeBody(),
        ),
      ),
    );
  }

  testWidgets('should show loading indicator when state is CurrencyInitial',
      (WidgetTester tester) async {
    when(mockCurrencyBloc.state).thenReturn(CurrencyInitial());

    when(mockCurrencyBloc.stream)
        .thenAnswer((_) => Stream.value(CurrencyInitial()));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(mockCurrencyBloc.add(argThat(isA<GetCurrencyRatesEvent>())))
        .called(1);
  });

  testWidgets('should show loading indicator when state is CurrencyLoading',
      (WidgetTester tester) async {
    // Arrange
    when(mockCurrencyBloc.state).thenReturn(CurrencyLoading());
    when(mockCurrencyBloc.stream)
        .thenAnswer((_) => Stream.value(CurrencyLoading()));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show content when state is CurrencyLoaded',
      (WidgetTester tester) async {
    // Arrange
    const loadedState = CurrencyLoaded(
      baseCurrency: UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
      convertedAmounts: [
        UiConvertedAmount(code: 'EUR', amount: 0.85),
        UiConvertedAmount(code: 'GBP', amount: 0.73),
      ],
      filteredCurrencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
      isLoadingChangeCurrency: false,
      currencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
    );

    when(mockCurrencyBloc.state).thenReturn(loadedState);
    when(mockCurrencyBloc.stream).thenAnswer((_) => Stream.value(loadedState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.byType(CurrencyDropdown), findsOneWidget);
    expect(find.byType(CurrencyListWidget), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should show loading overlay when currency is being changed',
      (WidgetTester tester) async {
    // Arrange
    const loadedState = CurrencyLoaded(
      baseCurrency: UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
      convertedAmounts: [
        UiConvertedAmount(code: 'EUR', amount: 0.85),
        UiConvertedAmount(code: 'GBP', amount: 0.73),
      ],
      filteredCurrencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
      isLoadingChangeCurrency: true,
      currencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
    );

    when(mockCurrencyBloc.state).thenReturn(loadedState);
    when(mockCurrencyBloc.stream).thenAnswer((_) => Stream.value(loadedState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.byType(CurrencyDropdown), findsOneWidget);
    expect(find.byType(CurrencyListWidget), findsOneWidget);
    // Should also find the circular progress indicator for the loading overlay
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error message when state is CurrencyError',
      (WidgetTester tester) async {
    // Arrange
    const errorState = CurrencyError(message: 'Failed to load currencies');

    when(mockCurrencyBloc.state).thenReturn(errorState);
    when(mockCurrencyBloc.stream).thenAnswer((_) => Stream.value(errorState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Error: Failed to load currencies'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    // Test retry button action
    await tester.tap(find.text('Retry'));
    verify(mockCurrencyBloc.add(argThat(isA<GetCurrencyRatesEvent>())))
        .called(1);
  });

  testWidgets('should call OnAmountChangedEvent when text field changes',
      (WidgetTester tester) async {
    // Arrange
    const loadedState = CurrencyLoaded(
      baseCurrency: UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
      convertedAmounts: [
        UiConvertedAmount(code: 'EUR', amount: 0.85),
        UiConvertedAmount(code: 'GBP', amount: 0.73),
      ],
      filteredCurrencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
      isLoadingChangeCurrency: false,
      currencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
    );

    when(mockCurrencyBloc.state).thenReturn(loadedState);
    when(mockCurrencyBloc.stream).thenAnswer((_) => Stream.value(loadedState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(AppTextField), '100');

    // Assert
    verify(mockCurrencyBloc.add(argThat(isA<OnAmountChangedEvent>())))
        .called(1);
  });

  testWidgets('should call ChangeCurrencyEvent when dropdown currency changes',
      (WidgetTester tester) async {
    // Arrange
    const loadedState = CurrencyLoaded(
      baseCurrency: UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
      convertedAmounts: [
        UiConvertedAmount(code: 'EUR', amount: 0.85),
        UiConvertedAmount(code: 'GBP', amount: 0.73),
      ],
      filteredCurrencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
      isLoadingChangeCurrency: false,
      currencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
    );

    when(mockCurrencyBloc.state).thenReturn(loadedState);
    when(mockCurrencyBloc.stream).thenAnswer((_) => Stream.value(loadedState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Find and trigger the onSelectedChanged callback on CurrencyDropdown
    final dropdownFinder = find.byType(CurrencyDropdown);
    expect(dropdownFinder, findsOneWidget);

    // This is a bit tricky as we need to extract the widget and call its callback
    final CurrencyDropdown dropdown = tester.widget(dropdownFinder);
    dropdown.onSelectedChanged(
      const UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
    );

    // Assert
    verify(mockCurrencyBloc.add(argThat(isA<ChangeCurrencyEvent>()))).called(1);
  });

  testWidgets('should call FilteredItemsEvent when dropdown text is filtered',
      (WidgetTester tester) async {
    // Arrange
    const loadedState = CurrencyLoaded(
      baseCurrency: UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
      convertedAmounts: [
        UiConvertedAmount(code: 'EUR', amount: 0.85),
        UiConvertedAmount(code: 'GBP', amount: 0.73),
      ],
      filteredCurrencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
      isLoadingChangeCurrency: false,
      currencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
    );

    when(mockCurrencyBloc.state).thenReturn(loadedState);
    when(mockCurrencyBloc.stream).thenAnswer((_) => Stream.value(loadedState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Find and trigger the onFilteredText callback on CurrencyDropdown
    final dropdownFinder = find.byType(CurrencyDropdown);
    expect(dropdownFinder, findsOneWidget);

    // This is a bit tricky as we need to extract the widget and call its callback
    final CurrencyDropdown dropdown = tester.widget(dropdownFinder);
    dropdown.onFilteredText('EU');

    // Assert
    verify(mockCurrencyBloc.add(argThat(isA<FilteredItemsEvent>()))).called(1);
  });

  testWidgets(
      'should call GetCurrencyRatesEvent when RefreshIndicator is triggered',
      (WidgetTester tester) async {
    // Arrange
    const loadedState = CurrencyLoaded(
      baseCurrency: UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
      convertedAmounts: [
        UiConvertedAmount(code: 'EUR', amount: 0.85),
        UiConvertedAmount(code: 'GBP', amount: 0.73),
      ],
      filteredCurrencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
      isLoadingChangeCurrency: false,
      currencyModels: [
        UiCurrencyModel(code: 'USD', description: 'USD', rate: 1.0),
        UiCurrencyModel(code: 'EUR', description: 'EUR', rate: 0.85),
        UiCurrencyModel(code: 'GBP', description: 'GBP', rate: 0.73),
      ],
    );

    when(mockCurrencyBloc.state).thenReturn(loadedState);
    when(mockCurrencyBloc.stream).thenAnswer((_) => Stream.value(loadedState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Trigger refresh indicator
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
    await tester.pumpAndSettle();

    // Assert
    verify(mockCurrencyBloc.add(argThat(isA<GetCurrencyRatesEvent>())))
        .called(1);
  });
}
