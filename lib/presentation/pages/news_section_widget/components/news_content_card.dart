import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/app_colors.dart';
import 'package:hr_tcc/config/themes/app_typography.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/news_section_widget/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class NewsContentCard extends StatelessWidget {
  final NewsCardModel model;

  const NewsContentCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.imageUrl != null)
          AppImageWithBorder(
            imageUrl: model.imageUrl ?? '',
            width: 60,
            height: 60,
            borderRadius: 0,
            borderWidth: 0,
            borderPadding: 0,
            borderColor: AppColors.transparent,
            imageRadius: 8,
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.notRead) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.green500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      model.time,
                      style: AppTypography.caption2Medium.copyWith(
                        color: AppColors.gray700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(model.title, style: AppTypography.text1Medium),
              const SizedBox(height: 4),
              Text(
                model.subtitle,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.text2Regular.copyWith(
                  color: AppColors.gray700,
                ),
              ),
              const SizedBox(height: 16),
              NewsBadge(title: model.category.title),
            ],
          ),
        ),
      ],
    );
  }
}
