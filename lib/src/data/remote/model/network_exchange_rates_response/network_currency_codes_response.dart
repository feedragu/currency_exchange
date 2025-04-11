import 'package:json_annotation/json_annotation.dart';

part 'network_currency_codes_response.g.dart';

@JsonSerializable()
class NetworkCurrencyCodesResponse {
  final String? result;
  final String? documentation;
  @JsonKey(name: 'terms_of_use')
  final String? termsOfUse;
  @JsonKey(name: 'supported_codes')
  final List<List<String>>? supportedCodes;

  NetworkCurrencyCodesResponse({
    this.result,
    this.documentation,
    this.termsOfUse,
    this.supportedCodes,
  });

  factory NetworkCurrencyCodesResponse.fromJson(Map<String, dynamic> json) =>
      _$NetworkCurrencyCodesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkCurrencyCodesResponseToJson(this);
}