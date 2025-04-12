import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
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
      final currencyRate = await getCurrencyRates.run();
      final convertedAmounts = await changeCurrency.run(
        request: ChangeCurrencyParams(
          newBaseCurrency: currencyRate.baseCurrency,
          amount: double.tryParse(
                amountController.text,
              ) ??
              1,
        ),
      );
      emit(
        CurrencyLoaded(
          baseCurrency: currencyRate.baseCurrency,
          currencyModels: currencyRate.currencyModels,
          filteredCurrencyModels: currencyRate.currencyModels,
          convertedAmounts: convertedAmounts
              .whereNot(
                (convertedAmount) =>
                    convertedAmount.code == currencyRate.baseCurrency.code,
              )
              .toList(),
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
          final convertedAmounts = await changeCurrency.run(
            request: ChangeCurrencyParams(
              newBaseCurrency: event.newBaseCurrency,
              amount: double.tryParse(amountController.text) ?? 1,
            ),
          );
          currencyController.text = event.newBaseCurrency.code;
          emit(
            currentState.copyWith(
              convertedAmounts: convertedAmounts
                  .whereNot(
                    (convertedAmount) =>
                        convertedAmount.code == event.newBaseCurrency.code,
                  )
                  .toList(),
              filteredCurrencyModels: currentState.currencyModels,
              baseCurrency: event.newBaseCurrency,
            ),
          );
        default:
          emit(const CurrencyError());
      }
    } on FormatException catch (_) {
      // ignore
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
                amount: double.tryParse(event.newAmount) ?? 1,
              ),
            );
            emit(
              currentState.copyWith(
                  convertedAmounts: result
                      .whereNot(
                        (convertedAmount) =>
                            convertedAmount.code ==
                            currentState.baseCurrency.code,
                      )
                      .toList(),),
            );
          }
        default:
          emit(const CurrencyError());
      }
    } on FormatException catch (_) {
      // ignore
    }
  }

  FutureOr<void> _onFilteredItemsEvent(
    FilteredItemsEvent event,
    Emitter<CurrencyState> emit,
  ) {
    try {
      final currentState = state;
      switch (currentState) {
        case CurrencyLoaded():
          if (event.filteredText.isNotEmpty) {
            emit(
              currentState.copyWith(
                filteredCurrencyModels: event.filteredText ==
                        currentState.baseCurrency.code
                    ? currentState.currencyModels
                    : currentState.currencyModels
                        .where(
                          (currencyModel) =>
                              currencyModel.code
                                  .toLowerCase()
                                  .contains(event.filteredText.toLowerCase()) ||
                              currencyModel.description
                                  .toLowerCase()
                                  .contains(event.filteredText.toLowerCase()),
                        )
                        .toList(),
              ),
            );
          }
        default:
          emit(const CurrencyError());
      }
    } on FormatException catch (_) {
      // ignore
    }
  }
}
