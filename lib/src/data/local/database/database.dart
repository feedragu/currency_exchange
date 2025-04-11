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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.drop(currencyRatesTable);
            await m.create(currencyRatesTable);
          }
        },
        // Useful for debugging
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

@DataClassName('Currency')
class CurrencyRatesTable extends Table {
  TextColumn get code => text().withLength(min: 3, max: 3)();

  TextColumn get description => text().nullable()();

  RealColumn get rate => real()();

  @override
  Set<Column> get primaryKey => {code};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    @visibleForTesting
    final file = File(p.join(dbFolder.path, databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
