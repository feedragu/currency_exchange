import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';

extension ConversionAmountExt on List<CurrencyModel> {
  List<UiCurrencyModel> toUiCurrencyModel() => map(
        (currencyModel) => UiCurrencyModel(
          code: currencyModel.code,
          description: currencyModel.description,
          rate: currencyModel.rate,
        ),
      ).toList();
}
