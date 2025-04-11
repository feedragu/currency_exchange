import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:currency_exchange/src/domain/usecases/model/app_use_case.dart';
import 'package:equatable/equatable.dart';

class ChangeCurrencyUseCase
    implements
        AppUseCaseWithRequest<Future<CurrencyRates>, ChangeCurrencyParams> {
  final CurrencyRepository repository;

  ChangeCurrencyUseCase(this.repository);

  @override
  Future<CurrencyRates> run({required ChangeCurrencyParams request}) {
    return repository.calculateCurrency(
      request.newBaseCurrency,
      request.amount,
    );
  }
}

class ChangeCurrencyParams extends Equatable {
  final String newBaseCurrency;
  final double amount;

  const ChangeCurrencyParams({
    required this.newBaseCurrency,
    required this.amount,
  });

  @override
  List<Object> get props => [newBaseCurrency];
}
