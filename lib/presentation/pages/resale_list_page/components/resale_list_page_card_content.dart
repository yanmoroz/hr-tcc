import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:intl/intl.dart';

class ResaleListPageCardContent extends StatelessWidget {
  final ResaleItemModel item;
  final VoidCallback onTapLock;

  const ResaleListPageCardContent({
    super.key,
    required this.item,
    required this.onTapLock,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(date);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Сегодня в $formattedTime';
    } else if (dateOnly == yesterday) {
      return 'Вчера в $formattedTime';
    } else {
      return DateFormat('dd.MM.yyyy в HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = item.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImageWithBorder(
              imageUrl: item.imageUrl,
              width: 100,
              height: 140,
              borderRadius: 8,
              borderColor: AppColors.gray200,
              borderWidth: 1.0,
              borderPadding: 0,
              imageRadius: 8,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$formattedPrice ₽', style: AppTypography.title3Bold),
                const SizedBox(height: 4),
                Text(item.title, style: AppTypography.text2Medium),
                Text(item.type, style: AppTypography.text2Regular),
                const SizedBox(height: 12),
                Text(
                  item.authorName,
                  style: AppTypography.caption2Medium.copyWith(
                    color: AppColors.gray700,
                  ),
                ),
                Text(
                  _formatDate(item.createdAt),
                  style: AppTypography.caption2Medium.copyWith(
                    color: AppColors.gray700,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
                  item.status.isLocked ? AppColors.white : AppColors.blue700,
              shadowColor: AppColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.gray500, width: 1),
              ),
            ),
            onPressed: onTapLock,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  item.status.isLocked
                      ? Assets.icons.resalePage.closedLockPage.path
                      : Assets.icons.resalePage.openLockPage.path,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  item.status.isLocked ? 'Снять бронь' : 'Забронировать',
                  style: AppTypography.text2Medium.copyWith(
                    color:
                        item.status.isLocked
                            ? AppColors.black
                            : AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
