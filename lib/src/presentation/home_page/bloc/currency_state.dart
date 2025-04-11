part of 'currency_bloc.dart';

sealed class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencyLoading extends CurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencyLoaded extends CurrencyState {
  final UiCurrencyModel baseCurrency;
  final bool isLoadingChangeCurrency;
  final List<UiCurrencyModel> currencyModels;
  final List<UiConvertedAmount> convertedAmounts;

  const CurrencyLoaded({
    required this.baseCurrency,
    required this.currencyModels,
    required this.convertedAmounts,
    this.isLoadingChangeCurrency = false,
  });

  @override
  List<Object> get props =>
      [baseCurrency, currencyModels, isLoadingChangeCurrency, convertedAmounts];

  CurrencyLoaded copyWith({
    UiCurrencyModel? baseCurrency,
    bool? isLoadingChangeCurrency,
    List<UiCurrencyModel>? currencyModels,
    List<UiConvertedAmount>? convertedAmounts,
  }) {
    return CurrencyLoaded(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      isLoadingChangeCurrency:
          isLoadingChangeCurrency ?? this.isLoadingChangeCurrency,
      currencyModels: currencyModels ?? this.currencyModels,
      convertedAmounts: convertedAmounts ?? this.convertedAmounts,
    );
  }
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError({required this.message});

  @override
  List<Object> get props => [message];
}
