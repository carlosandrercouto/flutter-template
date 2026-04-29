import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_template/core/helpers/shared_preferences_helper/shared_preferences_helper.dart';

class AppLocalizations {
  Map<String, String> _localizedStrings = {};

  Locale recoverDeviceLocale({Locale? locale}) {
    if (locale == null) {
      final Locale? savedLocale = _getSavedLocale();

      if (savedLocale != null) {
        return savedLocale;
      } else {
        return PlatformDispatcher.instance.locale;
      }
    } else {
      return locale;
    }
  }

  /// Carrega o arquivo JSON baseado no idioma do sistema ou no locale especificado.
  Future<void> load({Locale? locale}) async {
    // Se um locale for fornecido, usa-o; caso contrário, utiliza o locale do sistema.

    final String languageCode = recoverDeviceLocale(
      locale: locale,
    ).languageCode;

    try {
      await _loadAndParse(languageCode);
    } catch (error, stackTrace) {
      log(
        'Error $languageCode : $error',
        name: 'AppLocalizations : load',
      );
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'I18n error',
        printDetails: true,
      );
      // Fallback para português.
      await _loadAndParse('pt');
    }
  }

  Future<void> _loadAndParse(String code) async {
    final String jsonString = await rootBundle.loadString(
      'assets/lang/$code.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  /// O coração do sistema: busca a chave ou reporta erro
  String translate(String key) {
    if (key.isEmpty) return '';

    final value = _localizedStrings[key];

    if (value == null) {
      _reportMissingKey(key);
      return key; // Retorna a própria chave para debug visual na tela
    }

    return value;
  }

  void _reportMissingKey(String key) {
    log('Chave não encontrada: $key', name: 'AppLocalizations', level: 900);

    // Grava no Crashlytics para o time de QA/Produto saber o que falta
    FirebaseCrashlytics.instance.recordError(
      'Missing translation key: $key',
      StackTrace.current,
      reason: 'I18n error',
      printDetails: true,
    );
  }

  /// Recupera o idioma salvo no SharedPreferences, ou retorna null.
  Locale? _getSavedLocale() {
    final sharedPrererencesHelper = GetIt.I<SharedPreferencesHelper>();
    final String? savedLang = sharedPrererencesHelper.getStringValue(
      key: SharedPreferencesHelperKeys.currentLanguage,
    );
    if (savedLang == null) {
      return null;
    }
    return savedLang == 'pt'
        ? const Locale('pt', 'BR')
        : const Locale('en', 'US');
  }
}
