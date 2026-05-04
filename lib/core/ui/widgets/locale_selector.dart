import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template/core/providers/locale_provider.dart';

/// Widget global para seleção do idioma da aplicação.
///
/// Exibe um [DropdownButton] com as opções de locale disponíveis.
/// Ao selecionar um novo idioma, atualiza o [LocaleProvider] e persiste
/// a escolha nas SharedPreferences.
class LocaleSelector extends StatelessWidget {
  const LocaleSelector({super.key});

  static const _supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ];

  static const _localeLabels = {
    'pt': '🇧🇷  Português',
    'en': '🇺🇸  English',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2130),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2D3E)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: localeProvider.locale,
              dropdownColor: const Color(0xFF1E2130),
              icon: const Icon(
                Icons.language_rounded,
                color: Color(0xFF7C3AED),
                size: 18,
              ),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: _supportedLocales.map((locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(
                    _localeLabels[locale.languageCode] ?? locale.languageCode,
                  ),
                );
              }).toList(),
              onChanged: (Locale? newLocale) async {
                if (newLocale != null) {
                  await localeProvider.setLocale(newLocale);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
