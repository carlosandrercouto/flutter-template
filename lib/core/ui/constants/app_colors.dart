import 'package:flutter/material.dart';

/// Cores base do projeto.
///
/// Contém todas as cores utilizadas na aplicação organizadas por categoria.
class AppColors {
  AppColors._();

  // region: Negras / Textos
  // ===================================================================================================================

  /// Cor preta para textos em geral em modo claro.
  static const Color black = Color(0xFF000E32);

  /// Cor preta para textos em modo escuro.
  static const Color white = Color(0xFFFFFFFF);

  // region: Primárias
  // ===================================================================================================================

  /// Cor primária principal (roxo/violeta).
  static const Color primary = Color(0xFF7C3AED);

  /// Cor primária clara (hover states).
  static const Color primaryLight = Color(0xFF9F67FF);

  /// Cor primária escura.
  static const Color primaryDark = Color(0xFF5B21B6);

  // region: Secundárias
  // ===================================================================================================================

  /// Cor secundária.
  static const Color secondary = Color(0xFF6366F1);

  /// Cor secundária clara.
  static const Color secondaryLight = Color(0xFF818CF8);

  /// Cor secundária escura.
  static const Color secondaryDark = Color(0xFF4F46E5);

  // region: Acentos
  // ===================================================================================================================

  /// Cor de acento (destaques).
  static const Color accent = Color(0xFF22D3EE);

  // region: Neutras / Backgrounds
  // ===================================================================================================================

  /// Cor de background em modo claro.
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// Cor de background em modo escuro.
  static const Color backgroundDark = Color(0xFF0F172A);

  /// Cor de surface em modo claro.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Cor de surface em modo escuro.
  static const Color surfaceDark = Color(0xFF1E293B);

  /// Cor de card em modo claro.
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Cor de card em modo escuro.
  static const Color cardDark = Color(0xFF1E293B);

  // region: Estados / Feedback
  // ===================================================================================================================

  /// Cor de sucesso.
  static const Color success = Color(0xFF22C55E);

  /// Cor de warning / atenção.
  static const Color warning = Color(0xFFF59E0B);

  /// Cor de erro / danger.
  static const Color error = Color(0xFFEF4444);

  /// Cor de informação.
  static const Color info = Color(0xFF3B82F6);

  // region: Borders / Divisores
  // ===================================================================================================================

  /// Cor de borda em modo claro.
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Cor de borda em modo escuro.
  static const Color borderDark = Color(0xFF334155);

  /// Cor de divisor em modo claro.
  static const Color dividerLight = Color(0xFFE2E8F0);

  /// Cor de divisor em modo escuro.
  static const Color dividerDark = Color(0xFF334155);

  // region: Texto / On
  // ===================================================================================================================

  /// Cor de texto primario em modo claro.
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Cor de texto secundario em modo claro.
  static const Color textSecondaryLight = Color(0xFF475569);

  /// Cor de texto terciario em modo claro.
  static const Color textTertiaryLight = Color(0xFF64748B);

  /// Cor de texto com maior destaque em modo claro.
  static const Color textBlackedOutLight = Color(0xFF000E32);

  /// Cor de texto primario em modo escuro.
  static const Color textDark = Color(0xFFF8FAFC);

  /// Cor de texto secundario em modo escuro.
  static const Color textSecondaryDark = Color(0xFFCBD5E1);

  /// Cor de texto com maior destaque em modo escuro.
  static const Color textBlackedOutDark = Color(0xFFFFFFFF);

  // region: Icones
  // ===================================================================================================================

  /// Cor de ícones em modo claro.
  static const Color iconLight = Color(0xFF475569);

  /// Cor de ícones em modo escuro.
  static const Color iconDark = Color(0xFFCBD5E1);

  // region:Overlay
  // ===================================================================================================================

  /// Cor de overlay (scrims).
  static const Color overlay = Color(0x80000000);

  /// Cor de overlay claro.
  static const Color overlayLight = Color(0x33000000);
}