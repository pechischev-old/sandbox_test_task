import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'dtos/converter_dtos.dart';

// сделана простая конвертация данных в локальную бд, по-хорошему лучше сделать через модели хайва + адаптеры
class ConverterLocalApi {
  Future<void> saveCurrencies(List<String> currencies) async {
    var box = await Hive.openBox('currenciesBox');

    await box.put('currencies', jsonEncode(currencies));
    await box.close();
  }

  Future<List<String>> getCurrencies() async {
    var box = await Hive.openBox('currenciesBox');

    final currencies = await box.get('currencies', defaultValue: '');
    final json = jsonDecode(currencies);
    await box.close();
    return (json as List<dynamic>).map((e) => e as String).toList();
  }

  Future<void> saveCurrencyRates(
      String currency, List<CurrencyRateDto> rates) async {
    var box = await Hive.openBox(currency);
    await box.put(
        currency, jsonEncode(rates.map((dto) => dto.toJson()).toList()));
    await box.close();
  }

  Future<List<CurrencyRateDto>> getCurrencyRates(String currency) async {
    var box = await Hive.openBox(currency);
    final encodedRates = await box.get(currency, defaultValue: '');
    final rates = jsonDecode(encodedRates);
    await box.close();
    if (rates is List) {
      return rates.map((rate) => CurrencyRateDto.fromJson(rate)).toList();
    }

    return [];
  }
}
