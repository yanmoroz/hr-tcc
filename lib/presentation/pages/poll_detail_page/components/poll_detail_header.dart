import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/poll_detail_page/components/components.dart';

class PollDetailHeader extends StatelessWidget {
  final PollDetailModel model;
  const PollDetailHeader({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth - 32; // отступы 16 + 16
    const aspectRatio = 228 / 343;
    final imageHeight = imageWidth * aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (model.status != null && (model.status?.isNotEmpty ?? false))
              PollsDetailBadge(
                text: model.status ?? '',
                backgroundColor: AppColors.yellow100,
                textColor: AppColors.black,
              ),
            const Spacer(),
            if (model.time != null && (model.time?.isNotEmpty ?? false))
              Text(
                model.time ?? '',
                style: AppTypography.caption2Medium.copyWith(
                  color: AppColors.gray700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (model.imageUrl != null && (model.imageUrl?.isNotEmpty ?? false))
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: model.imageUrl ?? '',
                fit: BoxFit.cover,
                height: imageHeight,
                placeholder:
                    (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                errorWidget:
                    (context, url, error) => const Icon(Icons.image, size: 48),
              ),
            ),
          ),
        if (model.imageUrl != null && (model.imageUrl?.isNotEmpty ?? false))
          const SizedBox(height: 12),
        if (model.title != null && (model.title?.isNotEmpty ?? false))
          Text(model.title ?? '', style: AppTypography.title2Bold),
        if (model.title != null && (model.title?.isNotEmpty ?? false))
          const SizedBox(height: 8),
        if (model.description != null &&
            (model.description?.isNotEmpty ?? false))
          Text(model.description ?? '', style: AppTypography.text1Regular),
      ],
    );
  }
}
