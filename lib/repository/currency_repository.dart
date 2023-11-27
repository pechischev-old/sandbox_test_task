import 'package:sandbox_test_task/provider/converter_provider.dart';
import 'package:sandbox_test_task/provider/dtos/converter_dtos.dart';
import 'package:sandbox_test_task/provider/exchange_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CurrencyRepository {
  final _apiProvider = ExchangeApiProvider();
  final _localProvider = ConverterLocalApi();

  late final List<String> _currencies;

  Future<List<String>> getCurrencies() async {
    return _localProvider.getCurrencies();
  }

  Future<double> getRate(String currencyFrom, String currencyTo) async {
    final hasInternetConnection = await InternetConnectionChecker.createInstance().hasConnection;
    if (hasInternetConnection) {
      // если есть интернет, то запрашивает актуальные данные
      await fetchCurrencyRates(currencyFrom);
    }
    final rates = await _localProvider.getCurrencyRates(currencyFrom);

    try {
      final currencyRate = rates.firstWhere((element) => element.currency == currencyTo);
      return currencyRate.rate;
    } catch (e) {
      return 0;
    }
  }

  Future<void> fetchCurrencyRates(String currencyFrom) async {
    final dto = await _apiProvider.getLatestRates(
      currencyFrom: currencyFrom,
    );
    final rates = dto.rates.entries
        .map((entry) => CurrencyRateDto(currency: entry.key, rate: entry.value))
        .toList();
    await _localProvider.saveCurrencyRates(currencyFrom, rates);
  }

  Future<void> fetchCurrencies() async {
    try {
      final dto = await _apiProvider.getCurrencies();
      _currencies = dto.symbols.keys.toList();
    } catch (e) {
      _currencies = [];
    }
    await _localProvider.saveCurrencies(_currencies);
  }
}
