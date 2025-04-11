import 'package:bloc/bloc.dart';
import 'package:currency_exchange/src/domain/usecases/change_currency_use_case.dart';
import 'package:currency_exchange/src/domain/usecases/fetch_currency_rates_use_case.dart';
import 'package:equatable/equatable.dart';

part 'currency_event.dart';

part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final FetchCurrencyRatesUseCase getCurrencyRates;
  final ChangeCurrencyUseCase changeCurrency;

  CurrencyBloc({
    required this.getCurrencyRates,
    required this.changeCurrency,
  }) : super(CurrencyInitial()) {
    on<GetCurrencyRatesEvent>(_onGetCurrencyRates);
    on<ChangeCurrencyEvent>(_onChangeCurrency);
  }

  Future<void> _onGetCurrencyRates(GetCurrencyRatesEvent event,
      Emitter<CurrencyState> emit,) async {
    emit(CurrencyLoading());
    final result = await getCurrencyRates.run();

    emit(
      CurrencyLoaded(baseCurrency: result.baseCurrency, rates: result.rates),
    );
  }

  Future<void> _onChangeCurrency(ChangeCurrencyEvent event,
      Emitter<CurrencyState> emit,) async {
    emit(CurrencyLoading());
    final result = await changeCurrency.run(
      request: ChangeCurrencyParams(newBaseCurrency: event.newBaseCurrency,
      ),
    );
    emit(
      CurrencyLoaded(baseCurrency: result.baseCurrency, rates: result.rates),
    );
  }
}
