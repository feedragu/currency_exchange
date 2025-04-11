import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:currency_exchange/src/domain/use_case/change_currency_use_case.dart';
import 'package:currency_exchange/src/domain/use_case/fetch_currency_rates_use_case.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_converted_amount.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'currency_event.dart';
part 'currency_state.dart';

const String _usd = 'USD';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final FetchCurrencyRatesUseCase getCurrencyRates;
  final ChangeCurrencyUseCase changeCurrency;
  final TextEditingController currencyController;
  final TextEditingController amountController;

  CurrencyBloc({
    required this.getCurrencyRates,
    required this.changeCurrency,
    required this.currencyController,
    required this.amountController,
  }) : super(CurrencyInitial()) {
    on<GetCurrencyRatesEvent>(_onGetCurrencyRatesEvent);
    on<ChangeCurrencyEvent>(_onChangeCurrencyEvent);
    on<OnAmountChangedEvent>(_onAmountChangedEvent);
    on<FilteredItemsEvent>(_onFilteredItemsEvent);
  }

  Future<void> _onGetCurrencyRatesEvent(
    GetCurrencyRatesEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      emit(CurrencyLoading());
      currencyController.text = _usd;
      final result = await getCurrencyRates.run();
      final convertedAmounts = await changeCurrency.run(
        request: ChangeCurrencyParams(
          newBaseCurrency: result.baseCurrency,
          amount: double.parse(amountController.text),
        ),
      );
      emit(
        CurrencyLoaded(
          baseCurrency: result.baseCurrency,
          currencyModels: result.currencyModels,
          convertedAmounts: convertedAmounts,
        ),
      );
    } catch (e) {
      emit(CurrencyError(message: e.toString()));
    }
  }

  Future<void> _onChangeCurrencyEvent(
    ChangeCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      final currentState = state;
      switch (currentState) {
        case CurrencyLoaded():
          final result = await changeCurrency.run(
            request: ChangeCurrencyParams(
              newBaseCurrency: event.newBaseCurrency,
              amount: double.parse(amountController.text),
            ),
          );
          currencyController.text = event.newBaseCurrency.code;
          emit(currentState.copyWith(
            convertedAmounts: result,
            baseCurrency: event.newBaseCurrency,
          ));
        case CurrencyInitial():
        case CurrencyLoading():
        case CurrencyError():
      }
    } on FormatException catch (e) {
      emit(CurrencyError(message: e.toString()));
    }
  }

  FutureOr<void> _onAmountChangedEvent(
    OnAmountChangedEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      final currentState = state;
      switch (currentState) {
        case CurrencyLoaded():
          if (event.newAmount.isNotEmpty) {
            final result = await changeCurrency.run(
              request: ChangeCurrencyParams(
                newBaseCurrency: currentState.baseCurrency,
                amount: double.parse(event.newAmount),
              ),
            );
            emit(
              currentState.copyWith(convertedAmounts: result),
            );
          }
        case CurrencyInitial():
        case CurrencyLoading():
        case CurrencyError():
      }
    } on FormatException catch (e) {
      emit(CurrencyError(message: e.toString()));
    }
  }

  FutureOr<void> _onFilteredItemsEvent(
      FilteredItemsEvent event, Emitter<CurrencyState> emit) {}
}
