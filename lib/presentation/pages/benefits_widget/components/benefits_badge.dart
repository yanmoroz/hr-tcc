import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class BenefitsBadge extends StatelessWidget {
  final String text;
  const BenefitsBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.gradientGlass,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTypography.caption2Medium.copyWith(color: AppColors.white),
      ),
    );
  }
}
