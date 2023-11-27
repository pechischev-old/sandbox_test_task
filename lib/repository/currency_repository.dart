class CurrencyRepository {
  List<String> getCurrencies() {
    return ['EUR', 'USD', 'RUB', 'AMD'];
  }

  double getRate(String currencyFrom, String currencyTo) {
    return 1.5;
  }
}