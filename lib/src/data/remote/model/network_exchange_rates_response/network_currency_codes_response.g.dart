// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_currency_codes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkCurrencyCodesResponse _$NetworkCurrencyCodesResponseFromJson(
        Map<String, dynamic> json) =>
    NetworkCurrencyCodesResponse(
      result: json['result'] as String?,
      documentation: json['documentation'] as String?,
      termsOfUse: json['terms_of_use'] as String?,
      supportedCodes: (json['supported_codes'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$NetworkCurrencyCodesResponseToJson(
        NetworkCurrencyCodesResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'documentation': instance.documentation,
      'terms_of_use': instance.termsOfUse,
      'supported_codes': instance.supportedCodes,
    };
