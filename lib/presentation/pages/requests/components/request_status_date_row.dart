import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

import '../../../../core/utils/date_utils.dart';

class RequestStatusDateRow extends StatelessWidget {
  final Widget status;
  final DateTime date;
  final TextStyle? dateStyle;
  final EdgeInsetsGeometry? padding;

  const RequestStatusDateRow({
    super.key,
    required this.status,
    required this.date,
    this.dateStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          status,
          Text(
            'от ${AppDateUtils.formatDate(date)}',
            style:
                dateStyle ??
                AppTypography.text2Regular.copyWith(color: AppColors.gray700),
          ),
        ],
      ),
    );
  }
}
