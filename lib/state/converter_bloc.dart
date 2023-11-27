import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sandbox_test_task/repository/currency_repository.dart';

part 'converter_bloc.freezed.dart';

const _defaultCurrencyFrom = 'EUR';
const _defaultCurrencyTo = 'USD';

@freezed
class ConverterEvent with _$ConverterEvent {
  const ConverterEvent._();

  const factory ConverterEvent.init() = _InitEvent;

  const factory ConverterEvent.updateCurrencies() = _UpdateCurrenciesEvent;

  const factory ConverterEvent.setAmountFrom({
    required double amount,
  }) = _SetAmountFromEvent;

  const factory ConverterEvent.setCurrencyFrom({
    required String currency,
  }) = _SetCurrencyFromEvent;

  const factory ConverterEvent.setAmountTo({
    required double amount,
  }) = _SetAmountToEvent;

  const factory ConverterEvent.setCurrencyTo({
    required String currency,
  }) = _SetCurrencyToEvent;

  const factory ConverterEvent.swap() = _SwapDataEvent;
}

@freezed
class ConverterState with _$ConverterState {
  ConverterState._();

  factory ConverterState.loading() = _LoadingState;

  // TODO: rename state
  factory ConverterState.current({
    required String currencyFrom,
    required String currencyTo,
    required double amount,
    required double rate,
  }) = _CurrentState;
}

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  late final CurrencyRepository _repository;

  ConverterBloc({
    required CurrencyRepository repository,
  })  : _repository = repository,
        super(ConverterState.loading()) {
    on<_InitEvent>(_init);
    on<_UpdateCurrenciesEvent>(_updateCurrencies);
    on<_SetAmountFromEvent>(_setAmountFrom);
    on<_SetCurrencyFromEvent>(_setCurrencyFrom);
    on<_SetAmountToEvent>(_setAmountTo);
    on<_SetCurrencyToEvent>(_setCurrencyTo);
    on<_SwapDataEvent>(_swapData);

    add(const ConverterEvent.init());
  }

  Future<void> _init(
    _InitEvent event,
    Emitter<ConverterState> emitter,
  ) async {
    Future.wait([
      _repository.fetchCurrencies(),
      _repository.fetchCurrencyRates(_defaultCurrencyFrom)
    ]);

    final rate = await _repository.getRate(_defaultCurrencyFrom, _defaultCurrencyTo);
    emitter(
      ConverterState.current(
        currencyFrom: _defaultCurrencyFrom,
        currencyTo: _defaultCurrencyTo,
        amount: 1,
        rate: rate,
      ),
    );
  }

  Future<void> _updateCurrencies(
    _UpdateCurrenciesEvent event,
    Emitter<ConverterState> emitter,
  ) async {
    // call repository method for getting actual currencies value
  }

  Future<void> _setAmountFrom(
    _SetAmountFromEvent event,
    Emitter<ConverterState> emitter,
  ) async {
    state.maybeWhen(
      current: (_, __, ___, ____) {
        emitter(
          (state as _CurrentState).copyWith(amount: event.amount),
        );
      },
      orElse: () {},
    );
  }

  Future<void> _setCurrencyFrom(
    _SetCurrencyFromEvent event,
    Emitter<ConverterState> emitter,
  ) async {
    state.maybeWhen(
      current: (_, to, __, ___) async {
        final from = event.currency;
        final rate = await _repository.getRate(from, to);
        emitter(
          (state as _CurrentState).copyWith(currencyFrom: from, rate: rate),
        );
      },
      orElse: () {},
    );
  }

  Future<void> _setAmountTo(
    _SetAmountToEvent event,
    Emitter<ConverterState> emitter,
  ) async {
    state.maybeWhen(
      current: (_, __, ___, rate) {
        emitter(
          (state as _CurrentState).copyWith(amount: event.amount / rate),
        );
      },
      orElse: () {},
    );
  }

  Future<void> _setCurrencyTo(
    _SetCurrencyToEvent event,
    Emitter<ConverterState> emitter,
  ) async {
    state.maybeWhen(
      current: (from, __, ___, ____) async {
        final to = event.currency;
        final rate = await _repository.getRate(from, to);
        emitter(
          (state as _CurrentState).copyWith(currencyTo: to, rate: rate),
        );
      },
      orElse: () {},
    );
  }

  Future<void> _swapData(
    _SwapDataEvent event,
    Emitter<ConverterState> emitter,
  ) async {
    state.maybeWhen(
      current: (from, to, amount, _) async {
        final rate = await _repository.getRate(to, from);
        emitter(
          ConverterState.current(
            currencyFrom: to,
            currencyTo: from,
            rate: rate,
            amount: amount,
          ),
        );
      },
      orElse: () {},
    );
  }
}
