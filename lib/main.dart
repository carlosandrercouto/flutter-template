import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/helpers/environment_helper.dart';
import 'core/routes/routes.dart';
import 'core/routes/routes_list.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializa o Firebase
    await Firebase.initializeApp();

    // Passa todos os erros não capturados do "Flutter" para o Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Passa erros de plataforma para o Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Inicializa dados de formatação de datas (pacote intl)
    await initializeDateFormatting('pt_BR', null);

    // Inicializa o EnvironmentHelper lendo o arquivo .env
    // antes de qualquer inicialização de classes
    await EnvironmentHelper.instance.init();

    runApp(const FlutterTemplateApp());
  }, (error, stack) {
    // Passa todos os erros não capturados do "Dart" para o Crashlytics
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class FlutterTemplateApp extends StatelessWidget {
  const FlutterTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Template',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: RoutesList.LoginScreen.routeName,
      onGenerateRoute: getRoute,
    );
  }
}
