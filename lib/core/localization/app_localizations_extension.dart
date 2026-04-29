import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_template/core/localization/app_localizations.dart';
import 'package:flutter_template/core/providers/locale_provider.dart';

extension AppLocalizationsExtension on BuildContext {
  /// Traduz uma chave e faz o widget escutar mudanças de idioma automaticamente.
  /// Use [listen: false] quando chamar dentro de funções/callbacks (ex: onChanged, onPressed, validators).
  String translate(String key, {bool listen = true}) {
    if (listen) {
      watch<LocaleProvider>();
    }
    return GetIt.I<AppLocalizations>().translate(key);
  }
}
