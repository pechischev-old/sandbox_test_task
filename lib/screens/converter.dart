import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency exchange'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _MoneyTextField(
                    label: 'You send',
                  ),
                ),
                const Gap(20),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_down_sharp),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.import_export),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _MoneyTextField(
                    label: 'You get',
                  ),
                ),
                const Gap(20),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_down_sharp),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MoneyTextField extends StatelessWidget {
  final String label;

  const _MoneyTextField({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
      ],
      decoration: InputDecoration(labelText: label, hintText: 'Input value like 0.00'),
    );
  }
}
