import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class MorePageBadge extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color? backgroundColor;

  const MorePageBadge({
    super.key,
    required this.text,
    this.textColor = AppColors.white,
    this.backgroundColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: AppTypography.caption2Medium.copyWith(color: textColor)
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
