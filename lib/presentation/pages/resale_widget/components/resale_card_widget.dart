import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/resale_widget/components/components.dart';

class ResaleCardWidget extends StatelessWidget {
  final int cardsInRow;
  final Color priceColor;
  final Color descriptionColor;
  final String imageUrl;
  final String price;
  final String description;
  final SaleStatus saleStatus;
  final VoidCallback onTapLock;

  const ResaleCardWidget({
    super.key,
    this.cardsInRow = 2, // Влияет на пропорции карточки
    this.priceColor = AppColors.black,
    this.descriptionColor = AppColors.gray700,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.saleStatus,
    required this.onTapLock,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width =
            (MediaQuery.of(context).size.width - 16 * 2 - 8) / cardsInRow;
        final double height = width * (272 / 167); // Высота к ширене

        return SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height:
                          height -
                          60, // подгон под высоту изображения 60 текст карточки в высоту
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: OnSaleBadge(
                      model: OnSaleBadgeModel.fromStatus(saleStatus),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: LockIconButton(
                      isLocked: saleStatus.isLocked,
                      onTapLock: onTapLock,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: AppTypography.text1Semibold.copyWith(
                        color: priceColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.caption2Medium.copyWith(
                        color: descriptionColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
