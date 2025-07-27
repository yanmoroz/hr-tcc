import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class ResailDetailInfoTextBlock extends StatelessWidget {
  final String label;
  final String value;

  const ResailDetailInfoTextBlock({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.text2Regular.copyWith(
              color: AppColors.gray700,
            ),
          ),
          Text(value, style: AppTypography.text1Regular),
        ],
      ),
    );
  }
}
