part of 'currency_bloc.dart';

sealed class CurrencyEvent extends Equatable {
  const CurrencyEvent();
}

class GetCurrencyRatesEvent extends CurrencyEvent {
  @override
  List<Object> get props => [];
}

class OnAmountChangedEvent extends CurrencyEvent {
  final String newAmount;

  const OnAmountChangedEvent(this.newAmount);

  @override
  List<Object> get props => [];
}

class ChangeCurrencyEvent extends CurrencyEvent {
  final UiCurrencyModel newBaseCurrency;

  const ChangeCurrencyEvent(this.newBaseCurrency);

  @override
  List<Object> get props => [newBaseCurrency];
}

class FilteredItemsEvent extends CurrencyEvent {
  final String filteredText;

  const FilteredItemsEvent(this.filteredText);

  @override
  List<Object> get props => [filteredText];
}
