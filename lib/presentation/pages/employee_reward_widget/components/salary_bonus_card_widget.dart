import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class SalaryBonusCardWidget extends StatelessWidget {
  final String title;
  final String value;

  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color valueColor;
  final double borderRadiusValue;
  final double textSize;

  const SalaryBonusCardWidget({
    super.key,
    required this.title,
    required this.value,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.gray200,
    this.titleColor = AppColors.gray700,
    this.valueColor = AppColors.black,
    this.borderRadiusValue = 12.0,
    this.textSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 109,
      height: 54,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption2Medium.copyWith(color: titleColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.caption2Medium.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
