import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/benefits_widget/components/components.dart';

class BenefitsListCategoryCardContent extends StatelessWidget {
  final BenefitsItemModel model;

  const BenefitsListCategoryCardContent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BenefitsBadge(text: model.badgeTitle),
                const SizedBox(height: 8),
                Text(
                  maxLines: 3,
                  model.title,
                  style: AppTypography.text1Semibold.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  maxLines: 3,
                  model.subTitle,
                  style: AppTypography.text2Regular.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Text(
                  maxLines: 3,
                  model.expires,
                  style: AppTypography.caption2Medium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(model.icon, width: 110, height: 110),
          ),
        ],
      ),
    );
  }
}
