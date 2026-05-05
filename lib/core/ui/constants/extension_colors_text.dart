import 'package:flutter/material.dart';

class TextColors extends ThemeExtension<TextColors> {
  final Color withLink;
  final Color general;
  final Color secondary;
  final Color blackedOut;

  const TextColors({
    required this.withLink,
    required this.general,
    required this.secondary,
    required this.blackedOut,
  });

  @override
  ThemeExtension<TextColors> copyWith({
    Color? withLink,
    Color? general,
    Color? secondary,
    Color? blackedOut,
  }) {
    return TextColors(
      withLink: withLink ?? this.withLink,
      general: general ?? this.general,
      secondary: secondary ?? this.secondary,
      blackedOut: blackedOut ?? this.blackedOut,
    );
  }

  @override
  ThemeExtension<TextColors> lerp(ThemeExtension<TextColors>? other, double t) {
    if (other is! TextColors) {
      return this;
    }

    return TextColors(
      withLink: Color.lerp(withLink, other.withLink, t)!,
      general: Color.lerp(general, other.general, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      blackedOut: Color.lerp(blackedOut, other.blackedOut, t)!,
    );
  }
}
