import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class BenefitsPublicationAuthor extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String name;

  const BenefitsPublicationAuthor({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Row(
        children: [
          AppImageWithBorder(
            imageUrl: imageUrl,
            borderColor: AppColors.transparent,
            borderPadding: 0,
            borderWidth: 0,
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.text2Regular.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: AppTypography.text1Regular.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
