import 'package:flutter/material.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String userName;

  const HomeHeaderWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final textColors = Theme.of(context).extension<TextColors>();
    final firstName = userName.split(' ').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $firstName 👋',
                style: AppStyles.regular14().copyWith(
                  color: textColors?.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: AppStyles.bold20().copyWith(
                  color: textColors?.general,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                style: AppStyles.bold18().copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
