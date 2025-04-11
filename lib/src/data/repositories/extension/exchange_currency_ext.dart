import 'package:currency_exchange/src/data/remote/model/network_currency_codes_response/network_exchange_rates_response.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';

extension NetworkExchangeToCurrencyRatesDomain on NetworkExchangeRatesResponse {
  CurrencyRates? toCurrencyRatesDomain() {
    if (baseCurrency != null && conversionRates != null) {
      return CurrencyRates(
        baseCurrency: baseCurrency!,
        rates: conversionRates!,
      );
    }
    return null;
  }
}
