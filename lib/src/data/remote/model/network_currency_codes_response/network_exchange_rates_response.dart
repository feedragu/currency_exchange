import 'package:json_annotation/json_annotation.dart';

part 'network_exchange_rates_response.g.dart';

@JsonSerializable()
class NetworkExchangeRatesResponse {
  @JsonKey(name: 'result')
  final String? result;

  @JsonKey(name: 'documentation')
  final String? documentationUrl;

  @JsonKey(name: 'terms_of_use')
  final String? termsOfUseUrl;

  @JsonKey(name: 'time_last_update_unix')
  final int? lastUpdateUnix;

  @JsonKey(name: 'time_last_update_utc')
  final String? lastUpdateUtc;

  @JsonKey(name: 'time_next_update_unix')
  final int? nextUpdateUnix;

  @JsonKey(name: 'time_next_update_utc')
  final String? nextUpdateUtc;

  @JsonKey(name: 'base_code')
  final String? baseCurrency;

  @JsonKey(name: 'conversion_rates')
  final Map<String, double>? conversionRates;

  NetworkExchangeRatesResponse({
    this.result,
    this.documentationUrl,
    this.termsOfUseUrl,
    this.lastUpdateUnix,
    this.lastUpdateUtc,
    this.nextUpdateUnix,
    this.nextUpdateUtc,
    this.baseCurrency,
    this.conversionRates,
  });

  factory NetworkExchangeRatesResponse.fromJson(Map<String, dynamic> json) =>
      _$NetworkExchangeRatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkExchangeRatesResponseToJson(this);
}