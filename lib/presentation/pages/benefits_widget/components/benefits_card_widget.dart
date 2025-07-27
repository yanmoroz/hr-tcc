import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/benefits_widget/components/components.dart';

class BenefitsCardWidget extends StatelessWidget {
  final int cardsInRow;
  final BenefitsItemModel model;

  const BenefitsCardWidget({
    super.key,
    this.cardsInRow = 2, // Влияет на пропорции карточки
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width =
            (MediaQuery.of(context).size.width - 16 * 2 - 8) / cardsInRow;
        final double height = width * (216 / 167); // Высота к ширене

        return SizedBox(
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.gradientCardBenefits,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Контент слева сверху
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BenefitsBadge(text: model.badgeTitle),
                      const SizedBox(height: 8),
                      Text(
                        model.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.text1Semibold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.subTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.text2Regular.copyWith(
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        model.expires,
                        style: AppTypography.caption2Medium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Иконка снизу справа
                Align(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset(model.icon, width: 64, height: 64),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
