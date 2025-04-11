import 'package:currency_exchange/src/domain/extension/conversion_amount_ext.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:currency_exchange/src/domain/use_case/model/app_use_case.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_converted_amount.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:equatable/equatable.dart';

class ChangeCurrencyUseCase
    implements
        AppUseCaseWithRequest<Future<List<UiConvertedAmount>>,
            ChangeCurrencyParams> {
  final CurrencyRepository repository;

  ChangeCurrencyUseCase(this.repository);

  @override
  Future<List<UiConvertedAmount>> run({
    required ChangeCurrencyParams request,
  }) async {
    final newCalculatedAmounts = await repository.calculateCurrency(
      request.newBaseCurrency.code,
      request.amount,
    );
    return newCalculatedAmounts.toUiConvertedAmount();
  }
}

class ChangeCurrencyParams extends Equatable {
  final UiCurrencyModel newBaseCurrency;
  final double amount;

  const ChangeCurrencyParams({
    required this.newBaseCurrency,
    required this.amount,
  });

  @override
  List<Object> get props => [newBaseCurrency];
}
