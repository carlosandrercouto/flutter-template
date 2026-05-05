import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template/core/enums/app_theme_type_enum.dart';
import 'package:flutter_template/core/providers/theme_provider.dart';
import 'package:flutter_template/core/localization/app_localizations_extension.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';

/// Widget reutilizável para seleção de tema.
///
/// Exibe as opções "Automático" e "Modo Noturno".
/// Utiliza o [ThemeProvider] para persistir as alterações.
class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final currentTheme = themeProvider.currentTheme;
        final isAutomatic = currentTheme == AppThemeType.System;
        final isDarkMode =
            currentTheme == AppThemeType.MonDark ||
            (isAutomatic &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                context.translate('theme'),
                style: AppStyles.bold20().copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SwitchListTile.adaptive(
              title: Text(
                context.translate('automatic'),
                style: AppStyles.semiBold16(),
              ),
              subtitle: Text(
                context.translate('use_system_default'),
                style: AppStyles.regular14(),
              ),
              value: isAutomatic,
              // ignore: deprecated_member_use
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) {
                if (value) {
                  themeProvider.setTheme(AppThemeType.System);
                } else {
                  // Se desligar automático, mantém o tema que estava aparecendo visualmente
                  final brightness = MediaQuery.platformBrightnessOf(context);
                  themeProvider.setTheme(
                    brightness == Brightness.dark
                        ? AppThemeType.MonDark
                        : AppThemeType.MonLight,
                  );
                }
              },
            ),
            SwitchListTile.adaptive(
              title: Text(
                context.translate('dark_mode'),
                style: AppStyles.semiBold16(),
              ),
              value: isDarkMode,
              // ignore: deprecated_member_use
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) {
                // Ao forçar um tema manualmente, sai do modo automático
                themeProvider.setTheme(
                  value ? AppThemeType.MonDark : AppThemeType.MonLight,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
