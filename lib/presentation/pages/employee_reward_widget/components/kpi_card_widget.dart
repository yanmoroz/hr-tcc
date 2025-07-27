import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class KpiCardWidget extends StatelessWidget {
  final String title;
  final double progressPersent;

  final double borderRadiusValue;

  const KpiCardWidget({
    super.key,
    required this.title,
    required this.progressPersent,
    this.borderRadiusValue = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 109,
      height: 54,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.blue700,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTypography.caption2Medium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${progressPersent * 100}%',
                style: AppTypography.caption2Medium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          AppCircularProgressIndicator(
            progress: progressPersent,
            size: 24,
            progressStrokeColor: AppColors.white,
            backgroundPaintColor: AppColors.transparent,
            progressStroke: 4,
            showPercentage: false,
          ),
        ],
      ),
    );
  }
}
