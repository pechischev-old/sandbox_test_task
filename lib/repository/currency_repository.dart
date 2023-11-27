// получить список всех названий валют (сохранить в бд)
// получить список показателей для одной валюты - сохранить эти значения в бд ([currency]: { currencyTo, rate })
// если инета нет, то вывожу сохраненное значение
// если значения нет, то вывожу ошибку и ничего не меняю в модели

import 'package:sandbox_test_task/provider/exchange_provider.dart';

class CurrencyRepository {
  final _apiProvider = ExchangeApiProvider();

  late final List<String> _currencies;

  List<String> getCurrencies() {
    // get from db
    return _currencies;
  }

  Future<double> getRate(String currencyFrom, String currencyTo) async {
    // get value
    return 1.5;
  }

  Future<void> fetchCurrencyRates(String currencyFrom) async {
    final dto = await _apiProvider.getLatestRates(
        currencyFrom: currencyFrom,
    );
    final rates = dto.rates;

    // save to db
  }

  Future<void> fetchCurrencies() async {
    try {
      final dto = await _apiProvider.getCurrencies();
      _currencies = dto.symbols.keys.toList();
    } catch (e) {
      _currencies = [];
    }
    // save to db
  }
}