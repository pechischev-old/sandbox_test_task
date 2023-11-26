import 'package:flutter/material.dart';

import 'config/themes.dart';
import 'screens/converter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency converter',
      theme: lightTheme,
      darkTheme: darkTheme,
      supportedLocales: const [
        Locale('en'), // English
      ],
      home: const ConverterScreen(),
    );
  }
}
