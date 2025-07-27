import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';

class BenefitsListCategoriesCardContent extends StatelessWidget {
  final BenefitsListCategoriesModel model;

  const BenefitsListCategoriesCardContent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Stack(
        children: [
          // Текст слева по центру
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 110), // отступ под иконку
              child: Text(
                model.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.text1Semibold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          // Иконка снизу справа
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(model.icon, width: 110, height: 110),
          ),
        ],
      ),
    );
  }
}
