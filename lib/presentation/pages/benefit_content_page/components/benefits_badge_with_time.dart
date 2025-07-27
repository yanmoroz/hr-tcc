import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/pages/benefits_widget/components/components.dart';

class BenefitsBadgeWithTime extends StatelessWidget {
  final String badgeText;
  final String timeText;

  const BenefitsBadgeWithTime({
    super.key,
    required this.badgeText,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BenefitsBadge(text: badgeText),
        Text(
          timeText,
          style: AppTypography.caption2Medium.copyWith(
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
