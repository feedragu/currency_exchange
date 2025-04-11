import 'package:currency_exchange/src/data/remote/model/network_exchange_rates_response/network_currency_codes_response.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';

extension CurrencyCodesResponseToDomain on NetworkCurrencyCodesResponse {
  List<CurrencyCode> toCurrencyCodeDomain() {
    return supportedCodes
            ?.map(
              (item) => CurrencyCode(
                code: item.isNotEmpty ? item[0] : null,
                description: item.length > 1 ? item[1] : null,
              ),
            )
            .toList() ??
        [];
  }
}
