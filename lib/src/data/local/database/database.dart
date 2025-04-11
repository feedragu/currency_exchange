import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

const databaseName = 'currency_exchange.sqlite';

@DriftDatabase(tables: [CurrencyRatesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

class CurrencyRatesTable extends Table {
  TextColumn get baseCurrency => text()();

  TextColumn get ratesJson => text()();

  DateTimeColumn get lastUpdated => dateTime()();

  @override
  Set<Column> get primaryKey => {baseCurrency};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    @visibleForTesting
    final file = File(p.join(dbFolder.path, databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
