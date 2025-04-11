import 'dart:convert';

import 'package:currency_exchange/src/data/local/database/database.dart';
import 'package:currency_exchange/src/domain/model/currency_rates.dart';
import 'package:drift/drift.dart';

class CurrencyDao {
  final AppDatabase _db;

  CurrencyDao(this._db);

  Future<void> saveCurrencyRates(CurrencyRates currencyRates) async {
    final ratesJson = jsonEncode(currencyRates.rates);

    await _db.into(_db.currencyRatesTable).insertOnConflictUpdate(
          CurrencyRatesTableCompanion(
            baseCurrency: Value(currencyRates.baseCurrency),
            ratesJson: Value(ratesJson),
            lastUpdated: Value(currencyRates.lastUpdated ?? DateTime.now()),
          ),
        );
  }

  Future<CurrencyRates?> getCurrencyRates(String baseCurrency) async {
    final query = _db.select(_db.currencyRatesTable)
      ..where((tbl) => tbl.baseCurrency.equals(baseCurrency));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    final Map<String, dynamic> jsonMap = jsonDecode(result.ratesJson);
    final Map<String, double> rates = {};

    jsonMap.forEach((key, value) {
      rates[key] = (value is int) ? value.toDouble() : value;
    });

    return CurrencyRates(
      baseCurrency: result.baseCurrency,
      rates: rates,
      lastUpdated: result.lastUpdated,
    );
  }

  Future<List<String>> getAllBaseCurrencies() async {
    final query = _db.select(_db.currencyRatesTable);
    final results = await query.get();
    return results.map((row) => row.baseCurrency).toList();
  }

  Future<bool> hasStoredRates() async {
    final count = await (_db.selectOnly(_db.currencyRatesTable)
          ..addColumns([_db.currencyRatesTable.baseCurrency.count()]))
        .map(
          (row) => row.read(_db.currencyRatesTable.baseCurrency.count()) ?? 0,
        )
        .getSingle();

    return count > 0;
  }

  Future<void> clearAll() async {
    await _db.delete(_db.currencyRatesTable).go();
  }
}
