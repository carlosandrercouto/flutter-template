import 'package:flutter/material.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_background.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/transaction_entity.dart';

class TransactionItemWidget extends StatelessWidget {
  const TransactionItemWidget({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormatter = DateFormat('dd MMM', 'pt_BR');
    final textColors = Theme.of(context).extension<TextColors>();
    final bgColors = Theme.of(context).extension<BackgroundExtensionColors>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColors?.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bgColors?.onBackground ?? Colors.transparent, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColors?.onSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: AppStyles.medium16().copyWith(
                    color: textColors?.general,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  dateFormatter.format(transaction.date),
                  style: AppStyles.regular12().copyWith(
                    color: textColors?.secondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- ${formatter.format(transaction.amount)}',
            style: AppStyles.semiBold16().copyWith(
              color: textColors?.general,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
