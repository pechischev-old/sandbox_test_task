import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (error) {
    FlutterError.presentError(error);
    // Logger.captureFlutterException(error, error.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // Logger.capturePlatformException(error, stack);
    return true;
  };

  runApp(const App());
}
