part of 'currency_bloc.dart';

sealed class CurrencyEvent extends Equatable {
  const CurrencyEvent();
}

class GetCurrencyRatesEvent extends CurrencyEvent {
  @override
  List<Object> get props => [];
}

class ChangeCurrencyEvent extends CurrencyEvent {
  final String newBaseCurrency;

  const ChangeCurrencyEvent(this.newBaseCurrency);

  @override
  List<Object> get props => [newBaseCurrency];
}
