import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_dtos.freezed.dart';

part 'exchange_dtos.g.dart';

@freezed
class ExchangeCurrenciesDto with _$ExchangeCurrenciesDto {
  factory ExchangeCurrenciesDto({
    required Map<String, String> symbols,
  }) = _ExchangeCurrenciesDto;

  factory ExchangeCurrenciesDto.fromJson(Map<String, Object?> json) =>
      _$ExchangeCurrenciesDtoFromJson(json);
}

@freezed
class ExchangeLatestRatesDto with _$ExchangeLatestRatesDto {
  factory ExchangeLatestRatesDto({
    required Map<String, double> rates
}) = _ExchangeLatestRatesDto;
  factory ExchangeLatestRatesDto.fromJson(Map<String, Object?> json) =>
      _$ExchangeLatestRatesDtoFromJson(json);
}
