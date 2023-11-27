import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sandbox_test_task/model/currency_rate.dart';
import 'package:sandbox_test_task/state/converter_bloc.dart';

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
              current: (from, to) => _ConverterForm(from: from, to: to),
            );
          },
        ),
      ),
    );
  }
}

/// screen states

class _ConverterForm extends StatelessWidget {
  final CurrencyRate from;
  final CurrencyRate to;

  const _ConverterForm({required this.from, required this.to});

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
                value: from.amount,
                onChanged: (value) => context
                    .read<ConverterBloc>()
                    .add(ConverterEvent.setAmountFrom(amount: value)),
              ),
            ),
            const Gap(20),
            _CurrencySelector(
              currency: from.currency,
              onChanged: (currency) => context
                  .read<ConverterBloc>()
                  .add(ConverterEvent.setCurrencyFrom(currency: currency)),
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
                value: to.amount,
                onChanged: (value) => context
                    .read<ConverterBloc>()
                    .add(ConverterEvent.setAmountTo(amount: value)),
              ),
            ),
            const Gap(20),
            _CurrencySelector(
              currency: to.currency,
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
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
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

class _CurrenciesDropdownList extends StatelessWidget {
  final String selectedValue;

  const _CurrenciesDropdownList({
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: get list of currencies

    return Dialog(
      child: ListView.separated(
        itemBuilder: (_, index) => RadioListTile<String>(
          value: 'false',
          groupValue: selectedValue,
          onChanged: (value) {
            Navigator.pop(context);
          },
          title: const Text('Some text'),
        ),
        separatorBuilder: (_, __) => const Gap(10),
        itemCount: 8,
      ),
    );
  }
}
