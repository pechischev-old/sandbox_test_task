import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state/converter_bloc.dart';

import 'config/themes.dart';
import 'screens/converter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConverterBloc(),
      child: MaterialApp(
        title: 'Currency converter',
        theme: lightTheme,
        darkTheme: darkTheme,
        supportedLocales: const [
          Locale('en'), // English
        ],
        home: const ConverterScreen(),
      ),
    );
  }
}
