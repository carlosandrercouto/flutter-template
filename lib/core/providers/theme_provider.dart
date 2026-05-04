import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_template/core/helpers/shared_preferences_helper/shared_preferences_helper.dart';
import 'package:flutter_template/core/enums/app_theme_type_enum.dart';

/// Provider responsável por gerenciar o tema da aplicação.
///
/// Inicializa com o tema salvo nas SharedPreferences (chave `currentTheme`).
/// Caso não exista valor salvo, utiliza [AppThemeType.System] como padrão.
class ThemeProvider extends ChangeNotifier {
  AppThemeType _currentTheme;

  ThemeProvider({required AppThemeType initialTheme})
      : _currentTheme = initialTheme;

  /// Tema atual selecionado pelo usuário.
  AppThemeType get currentTheme => _currentTheme;

  /// Retorna o [ThemeMode] correspondente para ser usado no [MaterialApp].
  ThemeMode get themeMode {
    switch (_currentTheme) {
      case AppThemeType.MonLight:
        return ThemeMode.light;
      case AppThemeType.MonDark:
        return ThemeMode.dark;
      case AppThemeType.System:
        return ThemeMode.system;
    }
  }

  /// Atualiza o tema e persiste a escolha no [SharedPreferencesHelper].
  Future<void> setTheme(AppThemeType newTheme) async {
    if (newTheme == _currentTheme) return;
    _currentTheme = newTheme;

    final sharedPreferencesHelper = GetIt.I<SharedPreferencesHelper>();
    await sharedPreferencesHelper.saveStringValue(
      key: SharedPreferencesHelperKeys.currentTheme,
      value: newTheme.keyName,
    );

    notifyListeners();
  }
}
