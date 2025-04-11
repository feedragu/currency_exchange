import 'package:currency_exchange/src/domain/model/converted_amount.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_converted_amount.dart';

extension ConversionAmountExt on List<ConvertedAmount> {
  List<UiConvertedAmount> toUiConvertedAmount() => map(
        (convertedAmount) => UiConvertedAmount(
          code: convertedAmount.code,
          amount: convertedAmount.amount,
        ),
      ).toList();
}
