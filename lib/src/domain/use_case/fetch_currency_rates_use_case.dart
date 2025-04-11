import 'package:collection/collection.dart';
import 'package:currency_exchange/src/domain/extension/currency_model_ext.dart';
import 'package:currency_exchange/src/domain/model/currency_code.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:currency_exchange/src/domain/use_case/model/app_use_case.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_rate.dart';

/// Use case to fetch the latest exchange rates from USD
class FetchCurrencyRatesUseCase implements AppUseCase<Future<UiCurrencyRate>> {
  final CurrencyRepository repository;

  FetchCurrencyRatesUseCase(this.repository);

  @override
  Future<UiCurrencyRate> run() async {
    final results = await Future.wait([
      repository.getCurrencyRates(),
      repository.getExchangeCodes(),
    ]);

    final rates = results[0] as CurrencyRates;
    final codes = results[1] as List<CurrencyCode>;
    final List<CurrencyModel> currencyModel = rates.rates.entries
        .map(
          (entry) => CurrencyModel(
            code: entry.key,
            description: codes
                    .firstWhereOrNull((code) => code.code == entry.key)
                    ?.description ??
                '',
            rate: entry.value,
          ),
        )
        .toList();

    await repository.cacheCurrencyRates(
      currencyModel,
    );
    final uiCurrenciesModel = currencyModel.toUiCurrencyModel();
    if (uiCurrenciesModel.isNotEmpty) {
      return UiCurrencyRate(
        baseCurrency: uiCurrenciesModel.firstWhereOrNull(
              (currencyModel) => currencyModel.code == rates.baseCurrency,
            ) ??
            uiCurrenciesModel.first,
        currencyModels: uiCurrenciesModel,
      );
    } else {
      throw Exception();
    }
  }
}
