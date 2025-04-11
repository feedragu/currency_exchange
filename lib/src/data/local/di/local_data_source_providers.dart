import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source_impl.dart';
import 'package:currency_exchange/src/data/local/dao/currency_dao.dart';
import 'package:currency_exchange/src/data/local/di/database_providers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> localProviders() => [
      ...databaseProviders(),

      // Data sources
      ProxyProvider<CurrencyDao, CurrencyLocalDataSource>(
        update: (_, currencyDao, __) => CurrencyLocalDataSourceImpl(
          currencyDao: currencyDao,
        ),
      ),
    ];
