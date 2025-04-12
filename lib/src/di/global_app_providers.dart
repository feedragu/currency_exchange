import 'package:currency_exchange/src/core/env_config/env_config.dart';
import 'package:currency_exchange/src/core/network/di/app_dio_provider.dart';
import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/local/di/local_data_source_providers.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source.dart';
import 'package:currency_exchange/src/data/remote/currency_remote_data_source_impl.dart';
import 'package:currency_exchange/src/data/repositories/currency_repository_impl.dart';
import 'package:currency_exchange/src/domain/repositories/currency_repository.dart';
import 'package:currency_exchange/src/domain/use_case/change_currency_use_case.dart';
import 'package:currency_exchange/src/domain/use_case/fetch_currency_rates_use_case.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalAppProviders() => [
      // External dependencies
      dioProvider,

      // Database Providers

      ...localProviders(),

      // Data sources
      ProxyProvider<Dio, CurrencyRemoteDataSource>(
        update: (_, dio, __) => CurrencyRemoteDataSourceImpl(
          client: dio,
          apiKey: EnvConfig.currencyApiKey,
        ),
      ),

      // Repository
      ProxyProvider2<CurrencyRemoteDataSource, CurrencyLocalDataSource,
          CurrencyRepository>(
        update: (_, remoteDataSource, localDataSource, __) =>
            CurrencyRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
        ),
      ),

      // Use cases
      ProxyProvider<CurrencyRepository, FetchCurrencyRatesUseCase>(
        update: (_, repository, __) => FetchCurrencyRatesUseCase(
          repository,
        ),
      ),
      ProxyProvider<CurrencyRepository, ChangeCurrencyUseCase>(
        update: (_, repository, __) => ChangeCurrencyUseCase(
          repository,
        ),
      ),
    ];
