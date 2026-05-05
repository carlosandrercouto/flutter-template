import 'package:flutter/material.dart';
import 'package:flutter_template/core/localization/app_localizations_extension.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textColors = Theme.of(context).extension<TextColors>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 24),
        Text(
          context.translate('welcome_back'),
          style: AppStyles.bold28().copyWith(
            color: textColors?.general,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.translate('enter_with_your_credentials_to_login'),
          style: AppStyles.regular16().copyWith(
            color: textColors?.secondary,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
