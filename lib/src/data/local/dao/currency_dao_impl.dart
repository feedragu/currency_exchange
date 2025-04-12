import 'package:currency_exchange/src/data/local/dao/currency_dao.dart';
import 'package:currency_exchange/src/data/local/database/database.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';
import 'package:drift/drift.dart';

class CurrencyDaoImpl implements CurrencyDao {
  final AppDatabase _db;

  CurrencyDaoImpl(this._db);

  @override
  Future<void> saveCurrencies(List<CurrencyModel> currencyModels) async {
    await _db.transaction(() async {
      await clearAll();

      for (final currency in currencyModels) {
        await _db.into(_db.currencyRatesTable).insertOnConflictUpdate(
              CurrencyRatesTableCompanion(
                code: Value(currency.code),
                description: Value(currency.description),
                rate: Value(currency.rate),
              ),
            );
      }
    });
  }

  @override
  Future<List<CurrencyModel>?> getCurrencyRate() async {
    final query = _db.select(_db.currencyRatesTable);
    final results = await query.get();

    if (results.isEmpty) {
      return null;
    }

    // Convert database rows to CurrencyModel objects
    final List<CurrencyModel> currencyModels = results
        .map(
          (row) => CurrencyModel(
            code: row.code,
            description: row.description ?? row.code,
            rate: row.rate,
          ),
        )
        .toList();

    return currencyModels;
  }

  @override
  Future<List<String>> getAllBaseCurrencies() async {
    // Since we don't store base currencies explicitly in the new structure,
    // you might need to handle this differently in your application
    // This is a placeholder implementation
    final query = _db.select(_db.currencyRatesTable)
      ..where((tbl) => tbl.rate.equals(1.0));
    final results = await query.get();
    return results.map((row) => row.code).toList();
  }

  @override
  Future<bool> hasStoredCurrencies() async {
    final count = await (_db.selectOnly(_db.currencyRatesTable)
          ..addColumns([_db.currencyRatesTable.code.count()]))
        .map(
          (row) => row.read(_db.currencyRatesTable.code.count()) ?? 0,
        )
        .getSingle();

    return count > 0;
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.currencyRatesTable).go();
  }

  @override
  Future<void> addCurrency(String baseCurrency, CurrencyModel currency) async {
    await _db.into(_db.currencyRatesTable).insertOnConflictUpdate(
          CurrencyRatesTableCompanion(
            code: Value(currency.code),
            description: Value(currency.description),
            rate: Value(currency.rate),
          ),
        );
  }

  @override
  Future<CurrencyModel?> getCurrency(String code) async {
    final query = _db.select(_db.currencyRatesTable)
      ..where((tbl) => tbl.code.equals(code));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    return CurrencyModel(
      code: result.code,
      description: result.description ?? result.code,
      rate: result.rate,
    );
  }
}
