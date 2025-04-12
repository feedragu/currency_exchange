import 'package:currency_exchange/src/domain/model/currency_model.dart';

/// An abstract interface for currency data access operations.
/// This defines the contract that any currency data access implementation must follow.
abstract class CurrencyDao {
  /// Saves a list of currencies to the data store.
  ///
  /// [currencyModels] - The list of currency models to save.
  Future<void> saveCurrencies(List<CurrencyModel> currencyModels);

  /// Retrieves all currency rates from the data store.
  ///
  /// Returns a list of [CurrencyModel] objects, or null if no currencies are stored.
  Future<List<CurrencyModel>?> getCurrencyRate();

  /// Gets all base currencies from the data store.
  ///
  /// Returns a list of currency codes representing base currencies.
  Future<List<String>> getAllBaseCurrencies();

  /// Checks if there are any currencies stored in the data store.
  ///
  /// Returns true if currencies are stored, false otherwise.
  Future<bool> hasStoredCurrencies();

  /// Clears all currency data from the data store.
  Future<void> clearAll();

  /// Adds a currency for a specific base currency.
  ///
  /// [baseCurrency] - The base currency code.
  /// [currency] - The currency model to add.
  Future<void> addCurrency(String baseCurrency, CurrencyModel currency);

  /// Gets a specific currency by its code.
  ///
  /// [code] - The currency code.
  /// Returns the corresponding [CurrencyModel] or null if not found.
  Future<CurrencyModel?> getCurrency(String code);
}
