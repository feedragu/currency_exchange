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
  final Map<String, double> rates;

  const CurrencyLoaded({
    required this.baseCurrency,
    required this.rates,
  });

  @override
  List<Object> get props => [baseCurrency, rates];
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError({required this.message});

  @override
  List<Object> get props => [message];
}
