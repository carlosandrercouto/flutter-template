// ignore_for_file: constant_identifier_names

/// Enum para tipos de tema suportados pelo app.
enum AppThemeType {
  MonLight('AppTheme.MonLight'),
  MonDark('AppTheme.MonDark'),
  System('AppTheme.System');

  final String keyName;

  const AppThemeType(this.keyName);

  static AppThemeType getAppThemeType(String value) {
    try {
      return AppThemeType.values.firstWhere(
        (AppThemeType currencyType) => currencyType.keyName == value,
        orElse: () => AppThemeType.MonLight,
      );
    } catch (_) {
      return AppThemeType.MonLight;
    }
  }
}