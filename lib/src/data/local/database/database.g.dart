// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CurrencyRatesTableTable extends CurrencyRatesTable
    with TableInfo<$CurrencyRatesTableTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyRatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code, description, rate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_rates_table';
  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
    );
  }

  @override
  $CurrencyRatesTableTable createAlias(String alias) {
    return $CurrencyRatesTableTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final String code;
  final String? description;
  final double rate;
  const Currency({required this.code, this.description, required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['rate'] = Variable<double>(rate);
    return map;
  }

  CurrencyRatesTableCompanion toCompanion(bool nullToAbsent) {
    return CurrencyRatesTableCompanion(
      code: Value(code),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      rate: Value(rate),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      code: serializer.fromJson<String>(json['code']),
      description: serializer.fromJson<String?>(json['description']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'description': serializer.toJson<String?>(description),
      'rate': serializer.toJson<double>(rate),
    };
  }

  Currency copyWith(
          {String? code,
          Value<String?> description = const Value.absent(),
          double? rate}) =>
      Currency(
        code: code ?? this.code,
        description: description.present ? description.value : this.description,
        rate: rate ?? this.rate,
      );
  Currency copyWithCompanion(CurrencyRatesTableCompanion data) {
    return Currency(
      code: data.code.present ? data.code.value : this.code,
      description:
          data.description.present ? data.description.value : this.description,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, description, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.code == this.code &&
          other.description == this.description &&
          other.rate == this.rate);
}

class CurrencyRatesTableCompanion extends UpdateCompanion<Currency> {
  final Value<String> code;
  final Value<String?> description;
  final Value<double> rate;
  final Value<int> rowid;
  const CurrencyRatesTableCompanion({
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.rate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrencyRatesTableCompanion.insert({
    required String code,
    this.description = const Value.absent(),
    required double rate,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        rate = Value(rate);
  static Insertable<Currency> custom({
    Expression<String>? code,
    Expression<String>? description,
    Expression<double>? rate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (rate != null) 'rate': rate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrencyRatesTableCompanion copyWith(
      {Value<String>? code,
      Value<String?>? description,
      Value<double>? rate,
      Value<int>? rowid}) {
    return CurrencyRatesTableCompanion(
      code: code ?? this.code,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyRatesTableCompanion(')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('rate: $rate, ')
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
  required String code,
  Value<String?> description,
  required double rate,
  Value<int> rowid,
});
typedef $$CurrencyRatesTableTableUpdateCompanionBuilder
    = CurrencyRatesTableCompanion Function({
  Value<String> code,
  Value<String?> description,
  Value<double> rate,
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
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));
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
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);
}

class $$CurrencyRatesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrencyRatesTableTable,
    Currency,
    $$CurrencyRatesTableTableFilterComposer,
    $$CurrencyRatesTableTableOrderingComposer,
    $$CurrencyRatesTableTableAnnotationComposer,
    $$CurrencyRatesTableTableCreateCompanionBuilder,
    $$CurrencyRatesTableTableUpdateCompanionBuilder,
    (
      Currency,
      BaseReferences<_$AppDatabase, $CurrencyRatesTableTable, Currency>
    ),
    Currency,
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
            Value<String> code = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> rate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyRatesTableCompanion(
            code: code,
            description: description,
            rate: rate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            Value<String?> description = const Value.absent(),
            required double rate,
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyRatesTableCompanion.insert(
            code: code,
            description: description,
            rate: rate,
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
    Currency,
    $$CurrencyRatesTableTableFilterComposer,
    $$CurrencyRatesTableTableOrderingComposer,
    $$CurrencyRatesTableTableAnnotationComposer,
    $$CurrencyRatesTableTableCreateCompanionBuilder,
    $$CurrencyRatesTableTableUpdateCompanionBuilder,
    (
      Currency,
      BaseReferences<_$AppDatabase, $CurrencyRatesTableTable, Currency>
    ),
    Currency,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrencyRatesTableTableTableManager get currencyRatesTable =>
      $$CurrencyRatesTableTableTableManager(_db, _db.currencyRatesTable);
}
