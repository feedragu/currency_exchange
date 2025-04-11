import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/local/dao/currency_dao.dart';
import 'package:currency_exchange/src/domain/model/currency_rates_model.dart';

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final CurrencyDao currencyDao;

  CurrencyLocalDataSourceImpl({
    required this.currencyDao,
  });

  @override
  Future<CurrencyRatesModel> getLastCurrencyRates() async {
    try {
      // First try to get USD rates, as that's our primary data
      final usdRates = await currencyDao.getCurrencyRates('USD');

      if (usdRates != null) {
        return CurrencyRatesModel.fromEntity(usdRates);
      }

      // If USD rates aren't available, get any available rates
      final availableCurrencies = await currencyDao.getAllBaseCurrencies();

      if (availableCurrencies.isEmpty) {
        throw Exception('No cached exchange rates available');
      }

      final anyRates =
          await currencyDao.getCurrencyRates(availableCurrencies.first);

      if (anyRates == null) {
        throw Exception('Failed to retrieve cached exchange rates');
      }

      return CurrencyRatesModel.fromEntity(anyRates);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> cacheCurrencyRates(CurrencyRatesModel currencyRates) async {
    try {
      await currencyDao.saveCurrencyRates(currencyRates.toDomain());
    } catch (e) {
      throw Exception('Failed to cache currency rates: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasData() async {
    return await currencyDao.hasStoredRates();
  }
}
