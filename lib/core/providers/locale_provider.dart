import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_template/core/helpers/shared_preferences_helper/shared_preferences_helper.dart';
import 'package:flutter_template/core/localization/app_localizations.dart';

/// Provider responsável por gerenciar o locale da aplicação.
///
/// Inicializa com o locale salvo nas SharedPreferences (chave `currentLanguage`).
/// Caso não exista valor salvo, utiliza `Locale('en', 'US')` como padrão.
class LocaleProvider extends ChangeNotifier {
  Locale _currentLocale;

  LocaleProvider({required Locale initialLocale})
    : _currentLocale = initialLocale;

  /// Locale atual da aplicação.
  Locale get locale => _currentLocale;

  /// Atualiza o locale, recarrega as traduções e persiste a escolha.
  Future<void> setLocale(Locale setNewLocale) async {
    if (setNewLocale == _currentLocale) return;
    _currentLocale = setNewLocale;
    // Recarrega as strings de acordo com o novo locale.
    await GetIt.I<AppLocalizations>().load(locale: setNewLocale);
    // Persiste a escolha.
    final sharedPreferencesHelper = GetIt.I<SharedPreferencesHelper>();
    final localeKey = setNewLocale.languageCode; // 'en' ou 'pt'
    await sharedPreferencesHelper.saveStringValue(
      key: SharedPreferencesHelperKeys.currentLanguage,
      value: localeKey,
    );

    notifyListeners();
  }
}
