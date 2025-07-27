import 'dart:ui';

import 'package:hr_tcc/config/themes/themes.dart';

class OnSaleBadgeModel {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const OnSaleBadgeModel({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  factory OnSaleBadgeModel.fromStatus(SaleStatus status) {
    switch (status) {
      case SaleStatus.all:
        return const OnSaleBadgeModel(
          text: 'Все',
          backgroundColor: AppColors.gray200,
          textColor: AppColors.black,
        );

      case SaleStatus.reserved:
        return const OnSaleBadgeModel(
          text: 'Забронирован',
          backgroundColor: AppColors.gray200,
          textColor: AppColors.black,
        );
      case SaleStatus.onSale:
        return const OnSaleBadgeModel(
          text: 'В продаже',
          backgroundColor: AppColors.green500,
          textColor: AppColors.white,
        );
      case SaleStatus.removedFromSale:
        return const OnSaleBadgeModel(
          text: 'Снят с продажи',
          backgroundColor: AppColors.gray700,
          textColor: AppColors.white,
        );
    }
  }
}

enum SaleStatus { all, reserved, onSale, removedFromSale }

extension SaleStatusExtension on SaleStatus {
  bool get isLocked => this != SaleStatus.onSale;
}