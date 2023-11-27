import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();

  FlutterError.onError = (error) {
    FlutterError.presentError(error);
    log(error.toString(), error: error);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), error: error, stackTrace: stack);
    return true;
  };

  runApp(const App());
}
