import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sandbox_test_task/repository/currency_repository.dart';
import 'package:sandbox_test_task/state/converter_bloc.dart';
import 'package:sandbox_test_task/utils/formatters.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency exchange'),
      ),
      body: SafeArea(
        child: BlocBuilder<ConverterBloc, ConverterState>(
          builder: (context, state) {
            return state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              current: (from, to, amount, rate) => _ConverterForm(
                currencyFrom: from,
                currencyTo: to,
                amount: amount,
                rate: rate,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// screen states

class _ConverterForm extends StatelessWidget {
  final String currencyFrom;
  final String currencyTo;
  final double amount;
  final double rate;

  const _ConverterForm({
    required this.currencyFrom,
    required this.currencyTo,
    required this.amount,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _MoneyTextField(
                label: 'You send',
                value: amount,
                onChanged: (value) => context
                    .read<ConverterBloc>()
                    .add(ConverterEvent.setAmountFrom(amount: value)),
              ),
            ),
            const Gap(20),
            _CurrencySelector(
              currency: currencyFrom,
              onChanged: (currency) {
                context
                    .read<ConverterBloc>()
                    .add(ConverterEvent.setCurrencyFrom(currency: currency));
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: IconButton(
            onPressed: () =>
                context.read<ConverterBloc>().add(const ConverterEvent.swap()),
            icon: const Icon(Icons.import_export),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _MoneyTextField(
                label: 'You get',
                value: amount * rate,
                onChanged: (value) => context
                    .read<ConverterBloc>()
                    .add(ConverterEvent.setAmountTo(amount: value)),
              ),
            ),
            const Gap(20),
            _CurrencySelector(
              currency: currencyTo,
              onChanged: (currency) => context
                  .read<ConverterBloc>()
                  .add(ConverterEvent.setCurrencyTo(currency: currency)),
            ),
          ],
        )
      ],
    );
  }
}

class _MoneyTextField extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double>? onChanged;

  const _MoneyTextField({
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: value.toStringAsFixed(2),
          selection:
              TextSelection.collapsed(offset: value.toStringAsFixed(2).length),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Input value like 0.00',
      ),
      onChanged: (value) {
        onChanged?.call(double.tryParse(value) ?? 0);
      },
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  final String currency;
  final Function(String currency) onChanged;

  const _CurrencySelector({
    required this.currency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final newCurrencyValue = await showDialog<String?>(
          context: context,
          builder: (context) => _CurrenciesDropdownList(
            selectedValue: currency,
          ),
        );
        if (newCurrencyValue != null) {
          onChanged(newCurrencyValue);
        }
      },
      child: Row(
        children: [
          Text(currency),
          const Gap(8),
          const Icon(Icons.keyboard_arrow_down_sharp)
        ],
      ),
    );
  }
}

class _CurrenciesDropdownList extends StatefulWidget {
  final String selectedValue;

  const _CurrenciesDropdownList({
    required this.selectedValue,
  });

  @override
  State<_CurrenciesDropdownList> createState() =>
      _CurrenciesDropdownListState();
}

class _CurrenciesDropdownListState extends State<_CurrenciesDropdownList> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();

    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: context.read<CurrencyRepository>().getCurrencies(),
                builder: (context, snapshot) {
                  final currenciesList =
                      snapshot.hasData ? snapshot.requireData : [];
                  return ListView.separated(
                    itemBuilder: (_, index) {
                      final currency = currenciesList[index];
                      return RadioListTile<String>(
                        value: currency,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          if (value != null) {
                            selectedValue = value;
                            setState(() {});
                          }
                        },
                        title: Text(currency),
                      );
                    },
                    separatorBuilder: (_, __) => const Gap(10),
                    itemCount: currenciesList.length,
                  );
                }),
          ),
          ButtonBar(
            children: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context, selectedValue),
              ),
            ],
          )
        ],
      ),
    );
  }
}
