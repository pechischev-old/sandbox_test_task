import 'package:freezed_annotation/freezed_annotation.dart';

part 'converter_dtos.freezed.dart';
part 'converter_dtos.g.dart';

@freezed
class CurrencyRateDto with _$CurrencyRateDto {
  factory CurrencyRateDto({
    required String currency,
    required double rate,
  }) = _CurrencyRateDto;

  factory CurrencyRateDto.fromJson(Map<String, Object?> json) =>
      _$CurrencyRateDtoFromJson(json);
}