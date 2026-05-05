import 'package:flutter/material.dart';

class BackgroundExtensionColors
    extends ThemeExtension<BackgroundExtensionColors> {
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;

  const BackgroundExtensionColors({
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
  });

  @override
  ThemeExtension<BackgroundExtensionColors> lerp(
    covariant ThemeExtension<BackgroundExtensionColors>? other,
    double t,
  ) {
    if (other is! BackgroundExtensionColors) {
      return this;
    }

    return BackgroundExtensionColors(
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
    );
  }

  @override
  BackgroundExtensionColors copyWith({
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
  }) {
    return BackgroundExtensionColors(
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
    );
  }
}
