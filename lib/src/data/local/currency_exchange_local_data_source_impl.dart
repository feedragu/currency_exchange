import 'package:currency_exchange/src/data/local/currency_exchange_local_data_source.dart';
import 'package:currency_exchange/src/data/local/dao/currency_dao.dart';
import 'package:currency_exchange/src/domain/model/currency_model.dart';

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final CurrencyDao currencyDao;

  CurrencyLocalDataSourceImpl({
    required this.currencyDao,
  });

  @override
  Future<List<CurrencyModel>> getLastCurrencyRates() async {
    try {
      final anyRates = await currencyDao.getCurrencyRate();

      if (anyRates == null) {
        return [];
      }

      return anyRates;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheCurrencyRates(List<CurrencyModel> currencyModels) async {
    try {
      await currencyDao.saveCurrencies(currencyModels);
    } catch (e) {
      throw Exception('Failed to cache currency rates: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasData() async {
    return await currencyDao.hasStoredCurrencies();
  }
}
