// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CurrencyRatesTableTable extends CurrencyRatesTable
    with TableInfo<$CurrencyRatesTableTable, CurrencyRatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyRatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _baseCurrencyMeta =
      const VerificationMeta('baseCurrency');
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
      'base_currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ratesJsonMeta =
      const VerificationMeta('ratesJson');
  @override
  late final GeneratedColumn<String> ratesJson = GeneratedColumn<String>(
      'rates_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [baseCurrency, ratesJson, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_rates_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CurrencyRatesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('base_currency')) {
      context.handle(
          _baseCurrencyMeta,
          baseCurrency.isAcceptableOrUnknown(
              data['base_currency']!, _baseCurrencyMeta));
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('rates_json')) {
      context.handle(_ratesJsonMeta,
          ratesJson.isAcceptableOrUnknown(data['rates_json']!, _ratesJsonMeta));
    } else if (isInserting) {
      context.missing(_ratesJsonMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {baseCurrency};
  @override
  CurrencyRatesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyRatesTableData(
      baseCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_currency'])!,
      ratesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rates_json'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $CurrencyRatesTableTable createAlias(String alias) {
    return $CurrencyRatesTableTable(attachedDatabase, alias);
  }
}

class CurrencyRatesTableData extends DataClass
    implements Insertable<CurrencyRatesTableData> {
  final String baseCurrency;
  final String ratesJson;
  final DateTime lastUpdated;
  const CurrencyRatesTableData(
      {required this.baseCurrency,
      required this.ratesJson,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['base_currency'] = Variable<String>(baseCurrency);
    map['rates_json'] = Variable<String>(ratesJson);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  CurrencyRatesTableCompanion toCompanion(bool nullToAbsent) {
    return CurrencyRatesTableCompanion(
      baseCurrency: Value(baseCurrency),
      ratesJson: Value(ratesJson),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory CurrencyRatesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyRatesTableData(
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      ratesJson: serializer.fromJson<String>(json['ratesJson']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'ratesJson': serializer.toJson<String>(ratesJson),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  CurrencyRatesTableData copyWith(
          {String? baseCurrency, String? ratesJson, DateTime? lastUpdated}) =>
      CurrencyRatesTableData(
        baseCurrency: baseCurrency ?? this.baseCurrency,
        ratesJson: ratesJson ?? this.ratesJson,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  CurrencyRatesTableData copyWithCompanion(CurrencyRatesTableCompanion data) {
    return CurrencyRatesTableData(
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      ratesJson: data.ratesJson.present ? data.ratesJson.value : this.ratesJson,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyRatesTableData(')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('ratesJson: $ratesJson, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(baseCurrency, ratesJson, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyRatesTableData &&
          other.baseCurrency == this.baseCurrency &&
          other.ratesJson == this.ratesJson &&
          other.lastUpdated == this.lastUpdated);
}

class CurrencyRatesTableCompanion
    extends UpdateCompanion<CurrencyRatesTableData> {
  final Value<String> baseCurrency;
  final Value<String> ratesJson;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const CurrencyRatesTableCompanion({
    this.baseCurrency = const Value.absent(),
    this.ratesJson = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrencyRatesTableCompanion.insert({
    required String baseCurrency,
    required String ratesJson,
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  })  : baseCurrency = Value(baseCurrency),
        ratesJson = Value(ratesJson),
        lastUpdated = Value(lastUpdated);
  static Insertable<CurrencyRatesTableData> custom({
    Expression<String>? baseCurrency,
    Expression<String>? ratesJson,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (ratesJson != null) 'rates_json': ratesJson,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrencyRatesTableCompanion copyWith(
      {Value<String>? baseCurrency,
      Value<String>? ratesJson,
      Value<DateTime>? lastUpdated,
      Value<int>? rowid}) {
    return CurrencyRatesTableCompanion(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      ratesJson: ratesJson ?? this.ratesJson,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (ratesJson.present) {
      map['rates_json'] = Variable<String>(ratesJson.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyRatesTableCompanion(')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('ratesJson: $ratesJson, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrencyRatesTableTable currencyRatesTable =
      $CurrencyRatesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [currencyRatesTable];
}

typedef $$CurrencyRatesTableTableCreateCompanionBuilder
    = CurrencyRatesTableCompanion Function({
  required String baseCurrency,
  required String ratesJson,
  required DateTime lastUpdated,
  Value<int> rowid,
});
typedef $$CurrencyRatesTableTableUpdateCompanionBuilder
    = CurrencyRatesTableCompanion Function({
  Value<String> baseCurrency,
  Value<String> ratesJson,
  Value<DateTime> lastUpdated,
  Value<int> rowid,
});

class $$CurrencyRatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CurrencyRatesTableTable> {
  $$CurrencyRatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ratesJson => $composableBuilder(
      column: $table.ratesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));
}

class $$CurrencyRatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrencyRatesTableTable> {
  $$CurrencyRatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ratesJson => $composableBuilder(
      column: $table.ratesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$CurrencyRatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrencyRatesTableTable> {
  $$CurrencyRatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => column);

  GeneratedColumn<String> get ratesJson =>
      $composableBuilder(column: $table.ratesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);
}

class $$CurrencyRatesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrencyRatesTableTable,
    CurrencyRatesTableData,
    $$CurrencyRatesTableTableFilterComposer,
    $$CurrencyRatesTableTableOrderingComposer,
    $$CurrencyRatesTableTableAnnotationComposer,
    $$CurrencyRatesTableTableCreateCompanionBuilder,
    $$CurrencyRatesTableTableUpdateCompanionBuilder,
    (
      CurrencyRatesTableData,
      BaseReferences<_$AppDatabase, $CurrencyRatesTableTable,
          CurrencyRatesTableData>
    ),
    CurrencyRatesTableData,
    PrefetchHooks Function()> {
  $$CurrencyRatesTableTableTableManager(
      _$AppDatabase db, $CurrencyRatesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrencyRatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrencyRatesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrencyRatesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> baseCurrency = const Value.absent(),
            Value<String> ratesJson = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyRatesTableCompanion(
            baseCurrency: baseCurrency,
            ratesJson: ratesJson,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String baseCurrency,
            required String ratesJson,
            required DateTime lastUpdated,
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyRatesTableCompanion.insert(
            baseCurrency: baseCurrency,
            ratesJson: ratesJson,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrencyRatesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrencyRatesTableTable,
    CurrencyRatesTableData,
    $$CurrencyRatesTableTableFilterComposer,
    $$CurrencyRatesTableTableOrderingComposer,
    $$CurrencyRatesTableTableAnnotationComposer,
    $$CurrencyRatesTableTableCreateCompanionBuilder,
    $$CurrencyRatesTableTableUpdateCompanionBuilder,
    (
      CurrencyRatesTableData,
      BaseReferences<_$AppDatabase, $CurrencyRatesTableTable,
          CurrencyRatesTableData>
    ),
    CurrencyRatesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrencyRatesTableTableTableManager get currencyRatesTable =>
      $$CurrencyRatesTableTableTableManager(_db, _db.currencyRatesTable);
}
