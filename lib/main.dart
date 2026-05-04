import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/core/helpers/secure_storage_helper/secure_storage_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template/core/providers/locale_provider.dart';
import 'package:flutter_template/core/providers/theme_provider.dart';
import 'package:flutter_template/core/helpers/session_helper.dart';
import 'package:flutter_template/core/helpers/shared_preferences_helper/shared_preferences_helper.dart';
import 'package:flutter_template/core/localization/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/helpers/environment_helper.dart';
import 'core/routes/routes.dart';
import 'core/routes/routes_list.dart';
import 'core/enums/app_theme_type_enum.dart';
import 'core/ui/constants/app_themes.dart';

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

      /// Configura todas as dependências globais da aplicação.
      ///
      /// A ordem de registro garante que dependências assíncronas com [dependsOn]
      /// aguardem as suas dependências antes de executar o factory.
      Future<void> configureGlobalDependencies() async {
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

        // AppLocalizations — aguarda SharedPreferencesHelper e carrega o locale salvo.
        getIt.registerSingletonAsync<AppLocalizations>(
          () async {
            final localization = AppLocalizations();
            await localization.load();
            return localization;
          },
          dependsOn: [SharedPreferencesHelper],
        );

        // LocaleProvider — aguarda SharedPreferencesHelper para iniciar com o locale correto.
        getIt.registerSingletonAsync<LocaleProvider>(
          () async {
            final Locale recoverDeviceLocale = GetIt.I<AppLocalizations>()
                .recoverDeviceLocale();
            return LocaleProvider(initialLocale: recoverDeviceLocale);
          },
          dependsOn: [SharedPreferencesHelper, AppLocalizations],
        );

        // ThemeProvider — aguarda SharedPreferencesHelper.
        getIt.registerSingletonAsync<ThemeProvider>(
          () async {
            final sharedPreferencesHelper = GetIt.I<SharedPreferencesHelper>();
            final String? savedTheme = sharedPreferencesHelper.getStringValue(
              key: SharedPreferencesHelperKeys.currentTheme,
            );
            final AppThemeType initialTheme = savedTheme != null
                ? AppThemeType.getAppThemeType(savedTheme)
                : AppThemeType.System;
            return ThemeProvider(initialTheme: initialTheme);
          },
          dependsOn: [SharedPreferencesHelper],
        );
      }

      await configureGlobalDependencies();

      // Aguarda que AppLocalizations e LocaleProvider estejam prontos.
      await Future.wait([
        getIt.isReady<AppLocalizations>(),
        getIt.isReady<LocaleProvider>(),
        getIt.isReady<ThemeProvider>(),
      ]);

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LocaleProvider>.value(
              value: getIt<LocaleProvider>(),
            ),
            ChangeNotifierProvider<ThemeProvider>.value(
              value: getIt<ThemeProvider>(),
            ),
            // Futuramente outros providers globais podem ser adicionados aqui.
          ],
          child: const FlutterTemplateApp(),
        ),
      );
    },
    (error, stack) {
      // Passa todos os erros não capturados do "Dart" para o Crashlytics
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

/// Widget raiz da aplicação.
///
/// Observa o [LocaleProvider] para aplicar reativamente o locale
/// selecionado pelo usuário ao [MaterialApp].
class FlutterTemplateApp extends StatelessWidget {
  const FlutterTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Flutter Template',
      debugShowCheckedModeBanner: true,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: appThemeData[AppThemeType.MonLight],
      darkTheme: appThemeData[AppThemeType.MonDark],
      themeMode: themeProvider.themeMode,
      initialRoute: RoutesList.LoginScreen.routeName,
      onGenerateRoute: getRoute,
    );
  }
}
