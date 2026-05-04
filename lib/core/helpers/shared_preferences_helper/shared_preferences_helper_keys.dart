part of 'shared_preferences_helper.dart';

enum SharedPreferencesHelperKeys {
  currentLanguage('currentLanguage'),
  currentTheme('currentTheme'),
  ;

  final String keyName;

  const SharedPreferencesHelperKeys(this.keyName);
}
