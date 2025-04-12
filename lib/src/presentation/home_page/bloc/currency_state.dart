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
  final List<UiCurrencyModel> currencyModels;
  final List<UiCurrencyModel> filteredCurrencyModels;
  final List<UiConvertedAmount> convertedAmounts;

  const CurrencyLoaded({
    required this.baseCurrency,
    required this.currencyModels,
    required this.filteredCurrencyModels,
    required this.convertedAmounts,
    this.isLoadingChangeCurrency = false,
  });

  @override
  List<Object> get props => [
        baseCurrency,
        currencyModels,
        isLoadingChangeCurrency,
        convertedAmounts,
        filteredCurrencyModels,
      ];

  CurrencyLoaded copyWith({
    UiCurrencyModel? baseCurrency,
    bool? isLoadingChangeCurrency,
    List<UiCurrencyModel>? currencyModels,
    List<UiCurrencyModel>? filteredCurrencyModels,
    List<UiConvertedAmount>? convertedAmounts,
  }) {
    return CurrencyLoaded(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      isLoadingChangeCurrency:
          isLoadingChangeCurrency ?? this.isLoadingChangeCurrency,
      currencyModels: currencyModels ?? this.currencyModels,
      filteredCurrencyModels:
          filteredCurrencyModels ?? this.filteredCurrencyModels,
      convertedAmounts: convertedAmounts ?? this.convertedAmounts,
    );
  }
}

class CurrencyError extends CurrencyState {
  final String? message;

  const CurrencyError({this.message});

  @override
  List<Object?> get props => [message];
}
