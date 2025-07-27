import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/pages/more/components/components.dart';

class MoreContentCard extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? badgeTitle;
  final Color? backgroundBageColor;

  const MoreContentCard({
    super.key,
    required this.title,
    this.subTitle,
    this.badgeTitle,
    this.backgroundBageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.text1Medium),
                const SizedBox(height: 4),
                if (subTitle != null)
                  Text(
                    subTitle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.text2Regular.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              if (badgeTitle != null)
                MorePageBadge(
                  text: badgeTitle ?? '',
                  backgroundColor: backgroundBageColor,
                ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                Assets.icons.morePage.shevronRight.path,
                width: 5,
                height: 10,
              ),
              const SizedBox(width: 6),
            ],
          ),
        ],
      ),
    );
  }
}
