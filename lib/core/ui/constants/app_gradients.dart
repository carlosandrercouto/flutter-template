import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradientes utilizados no app.
class AppGradients {
  AppGradients._();

  /// Gradiente primário (roxo para violeta).
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente secundário (indigo para violeta).
  static const LinearGradient secondary = LinearGradient(
    colors: [AppColors.secondaryDark, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de background para modo claro.
  static const LinearGradient backgroundLight = LinearGradient(
    colors: [AppColors.backgroundLight, Color(0xFFEFF6FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradiente de background para modo escuro.
  static const LinearGradient backgroundDark = LinearGradient(
    colors: [AppColors.backgroundDark, Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradiente de acento (cyan).
  static const LinearGradient accent = LinearGradient(
    colors: [Color(0xFF06B6D4), AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}