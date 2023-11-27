import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

import 'dtos/exchange_dtos.dart';

part 'exchange_provider.g.dart';

// TODO: get this value from .env
const _accessKey = 'e26bdc95b62866ffa6d5e58f4abadeaf';

@RestApi()
abstract class ExchangeApiProvider {
  factory ExchangeApiProvider() {
    final client = Dio(
      BaseOptions(
        baseUrl: "http://api.exchangeratesapi.io/v1/",
        queryParameters: {
          'access_key': _accessKey
        }
      ),
    );
    client.interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        requestBody: true,
        logPrint: (logMsg) => log(
          logMsg.toString(),
          time: DateTime.now(),
        ),
      ),
    );

    return _ExchangeApiProvider(client);
  }

  @GET('/symbols')
  Future<ExchangeCurrenciesDto> getCurrencies();

  @GET('/latest')
  Future<ExchangeLatestRatesDto> getLatestRates({
    @Query('base') String? currencyFrom,
  });
}
