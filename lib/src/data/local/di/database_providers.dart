import 'package:currency_exchange/src/data/local/dao/currency_dao.dart';
import 'package:currency_exchange/src/data/local/dao/currency_dao_impl.dart';
import 'package:currency_exchange/src/data/local/database/database.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> databaseProviders() => [
      Provider<AppDatabase>(
        create: (_) => AppDatabase(),
      ),
      ProxyProvider<AppDatabase, CurrencyDao>(
        update: (_, appDatabase, currencyDao) => CurrencyDaoImpl(
          appDatabase,
        ),
      ),
    ];
