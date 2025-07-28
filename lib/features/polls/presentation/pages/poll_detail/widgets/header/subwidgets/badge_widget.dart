import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const BadgeWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTypography.caption2Medium.copyWith(color: textColor),
      ),
    );
  }
}
