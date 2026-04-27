import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/helpers/secure_storage_helper/secure_storage_helper.dart';
import 'package:flutter_template/core/helpers/session_helper.dart';
import 'package:flutter_template/core/helpers/shared_preferences_helper/shared_preferences_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/helpers/environment_helper.dart';
import 'core/routes/routes.dart';
import 'core/routes/routes_list.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Inicialização firebase e crashlytics
      await Firebase.initializeApp();

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Inicializa dados de formatação de datas (pacote intl)
      await initializeDateFormatting('pt_BR', null);

      final getIt = GetIt.instance;

      /// Dependency Injection
      Future<void> configureDependencies() async {
        // SecureStorageHelper
        getIt.registerSingleton<SecureStorageHelper>(SecureStorageHelper());
        // EnvironmentHelper
        getIt.registerSingletonAsync<EnvironmentHelper>(() async {
          final environmentHelper = EnvironmentHelper();
          await environmentHelper.init();
          return environmentHelper;
        });
        // SharedPreferencesHelper
        getIt.registerSingletonAsync<SharedPreferencesHelper>(() async {
          final sharedPreferencesHelper = SharedPreferencesHelper();
          await sharedPreferencesHelper.init();
          return sharedPreferencesHelper;
        });
        // SessionHelper
        getIt.registerSingleton<SessionHelper>(SessionHelper());
      }

      await configureDependencies();

      runApp(const FlutterTemplateApp());
    },
    (error, stack) {
      // Passa todos os erros não capturados do "Dart" para o Crashlytics
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
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
