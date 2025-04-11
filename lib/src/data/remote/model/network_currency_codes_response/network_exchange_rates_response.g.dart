// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_exchange_rates_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkExchangeRatesResponse _$NetworkExchangeRatesResponseFromJson(
        Map<String, dynamic> json) =>
    NetworkExchangeRatesResponse(
      result: json['result'] as String?,
      documentationUrl: json['documentation'] as String?,
      termsOfUseUrl: json['terms_of_use'] as String?,
      lastUpdateUnix: (json['time_last_update_unix'] as num?)?.toInt(),
      lastUpdateUtc: json['time_last_update_utc'] as String?,
      nextUpdateUnix: (json['time_next_update_unix'] as num?)?.toInt(),
      nextUpdateUtc: json['time_next_update_utc'] as String?,
      baseCurrency: json['base_code'] as String?,
      conversionRates: (json['conversion_rates'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$NetworkExchangeRatesResponseToJson(
        NetworkExchangeRatesResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'documentation': instance.documentationUrl,
      'terms_of_use': instance.termsOfUseUrl,
      'time_last_update_unix': instance.lastUpdateUnix,
      'time_last_update_utc': instance.lastUpdateUtc,
      'time_next_update_unix': instance.nextUpdateUnix,
      'time_next_update_utc': instance.nextUpdateUtc,
      'base_code': instance.baseCurrency,
      'conversion_rates': instance.conversionRates,
    };
