import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:intl/intl.dart';

class BenefitsPostStatsRow extends StatelessWidget {
  final int likes;
  final int comments;
  final bool isLiked;
  final VoidCallback? onLikePressed;
  final VoidCallback? onCommentPressed;

  const BenefitsPostStatsRow({
    super.key,
    required this.likes,
    required this.comments,
    required this.isLiked,
    this.onLikePressed,
    this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return SizedBox(
      height: 88,
      child: Row(
        children: [
          GestureDetector(
            onTap: onLikePressed,
            behavior: HitTestBehavior.opaque,
            child:
                isLiked
                    ? SvgPicture.asset(
                      Assets.icons.benefitContent.favorite.path,
                      width: 24,
                      height: 24,
                    )
                    : SvgPicture.asset(
                      Assets.icons.benefitContent.favoriteBorder.path,
                      width: 24,
                      height: 24,
                    ),
          ),
          const SizedBox(width: 12),
          Text(
            formatter.format(likes),
            style: AppTypography.caption2Medium.copyWith(
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onCommentPressed,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.benefitContent.chatBubbleOutline.path,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  formatter.format(comments),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatter.format(comments),
            style: AppTypography.caption2Medium.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
