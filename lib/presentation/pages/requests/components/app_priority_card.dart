import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class AppPriorityCard extends StatelessWidget {
  final String priority;
  const AppPriorityCard({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final isUrgent = priority.trim().toLowerCase() == 'срочно';
    final bgColor = isUrgent ? AppColors.orange100 : AppColors.green100;
    final iconColor = isUrgent ? AppColors.orange500 : AppColors.green500;
    final icon = Assets.icons.common.time.svg(
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      width: 24,
      height: 24,
    );
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Срочность',
                  style: AppTypography.text2Regular.copyWith(
                    color: AppColors.gray700,
                  ),
                ),
                const Gap(2),
                Text(
                  priority,
                  style: AppTypography.text1Regular.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          icon,
        ],
      ),
    );
  }
}
