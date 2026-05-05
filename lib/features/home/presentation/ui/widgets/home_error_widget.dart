import 'package:flutter/material.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';

class HomeErrorWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onTap;

  const HomeErrorWidget({
    super.key,
    required this.icon,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColors = Theme.of(context).extension<TextColors>();

    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColors?.secondary, size: 42),
              const SizedBox(height: 12),
              Text(
                message,
                style: AppStyles.regular14().copyWith(
                  color: textColors?.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
