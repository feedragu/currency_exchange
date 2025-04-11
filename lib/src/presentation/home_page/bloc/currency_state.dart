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
  final String baseCurrency;
  final bool isLoadingChangeCurrency;
  final Map<String, double> rates;

  const CurrencyLoaded({
    required this.baseCurrency,
    required this.rates,
    this.isLoadingChangeCurrency = false,
  });

  @override
  List<Object> get props => [baseCurrency, rates, isLoadingChangeCurrency];

  CurrencyLoaded copyWith({
    String? baseCurrency,
    bool? isLoadingChangeCurrency,
    Map<String, double>? rates,
  }) {
    return CurrencyLoaded(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      isLoadingChangeCurrency:
          isLoadingChangeCurrency ?? this.isLoadingChangeCurrency,
      rates: rates ?? this.rates,
    );
  }
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError({required this.message});

  @override
  List<Object> get props => [message];
}
