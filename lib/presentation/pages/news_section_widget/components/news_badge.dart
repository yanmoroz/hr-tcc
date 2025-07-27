import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class NewsBadge extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  const NewsBadge({
    super.key,
    required this.title,
    this.backgroundColor = AppColors.blue200,
    this.textColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(title, style: AppTypography.caption2Medium),
    );
  }
}
