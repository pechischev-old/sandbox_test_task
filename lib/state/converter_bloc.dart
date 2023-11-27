import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sandbox_test_task/model/currency_rate.dart';

part 'converter_bloc.freezed.dart';

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
    required CurrencyRate from,
    required CurrencyRate to,
  }) = _CurrentState;
}

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  ConverterBloc() : super(ConverterState.loading()) {
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
    emitter(
      ConverterState.current(
        from: const CurrencyRate(currency: 'EUR', amount: 1),
        to: const CurrencyRate(currency: 'USD', amount: 1),
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
      current: (from, to) {
        const rate = 1.5; // TODO: get actual rate for currency
        emitter(
          ConverterState.current(
            from: from.copyWith(amount: event.amount),
            to: to.copyWith(amount: event.amount * rate),
          ),
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
      current: (from, to) {
        emitter(
          ConverterState.current(
            from: from.copyWith(currency: event.currency),
            to: to,
          ),
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
      current: (from, to) {
        const rate = 1.5; // TODO: get actual rate for currency
        emitter(
          ConverterState.current(
            from: to.copyWith(amount: event.amount / rate),
            to: to.copyWith(amount: event.amount),
          ),
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
      current: (from, to) {
        emitter(
          ConverterState.current(
            from: from,
            to: to.copyWith(currency: event.currency),
          ),
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
      current: (from, to) {
        emitter(
          ConverterState.current(
            from: from.copyWith(currency: to.currency),
            to: to.copyWith(currency: from.currency),
          ),
        );
      },
      orElse: () {},
    );
  }
}
