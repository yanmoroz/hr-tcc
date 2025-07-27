import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AdressBookBadge extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final double borderRadius;
  final Color backgroundColor;

  const AdressBookBadge({
    super.key,
    required this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 4,
    this.backgroundColor = AppColors.gray100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(label, style: AppTypography.caption2Medium),
    );
  }
}
