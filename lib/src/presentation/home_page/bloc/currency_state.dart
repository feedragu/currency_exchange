part of 'currency_bloc.dart';

sealed class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final UiCurrencyModel baseCurrency;
  final bool isLoadingChangeCurrency;
  final bool amountError;
  final List<UiCurrencyModel> currencyModels;
  final List<UiCurrencyModel> filteredCurrencyModels;
  final List<UiConvertedAmount> convertedAmounts;

  const CurrencyLoaded({
    required this.baseCurrency,
    required this.currencyModels,
    required this.filteredCurrencyModels,
    required this.convertedAmounts,
    this.isLoadingChangeCurrency = false,
    this.amountError = false,
  });

  @override
  List<Object> get props => [
        baseCurrency,
        currencyModels,
        isLoadingChangeCurrency,
        amountError,
        convertedAmounts,
        filteredCurrencyModels,
      ];

  CurrencyLoaded copyWith({
    UiCurrencyModel? baseCurrency,
    bool? isLoadingChangeCurrency,
    bool? amountError,
    List<UiCurrencyModel>? currencyModels,
    List<UiCurrencyModel>? filteredCurrencyModels,
    List<UiConvertedAmount>? convertedAmounts,
  }) {
    return CurrencyLoaded(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      isLoadingChangeCurrency:
          isLoadingChangeCurrency ?? this.isLoadingChangeCurrency,
      amountError: amountError ?? this.amountError,
      currencyModels: currencyModels ?? this.currencyModels,
      filteredCurrencyModels:
          filteredCurrencyModels ?? this.filteredCurrencyModels,
      convertedAmounts: convertedAmounts ?? this.convertedAmounts,
    );
  }
}

class CurrencyError extends CurrencyState {
  final Object? exception;

  const CurrencyError({this.exception});

  @override
  List<Object?> get props => [exception];
}
