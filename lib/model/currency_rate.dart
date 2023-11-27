import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_rate.freezed.dart';

@freezed
class CurrencyRate with _$CurrencyRate {
  const factory CurrencyRate({
    required String currency,
    required double amount,
    // required double rate,
  }) = _CurrencyRate;
}