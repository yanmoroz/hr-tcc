import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class GeneralInfoSection extends StatelessWidget {
  final CourierRequestDetails details;
  const GeneralInfoSection({super.key, required this.details});

  String _deliveryTypeName(CourierDeliveryType type) {
    switch (type) {
      case CourierDeliveryType.moscow:
        return 'Курьер по Москве';
      case CourierDeliveryType.regions:
        return 'Экспресс-доставка по регионам';
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = details;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Курьерская доставка', style: AppTypography.title2Bold),
        const Gap(12),
        const SectionLabel('Тип заявки'),
        Text(
          _deliveryTypeName(d.deliveryType),
          style: AppTypography.text1Regular,
        ),
        const Gap(16),
        const SectionLabel('Обоснование выбора услуг экспресс-доставки'),
        Text(d.expReason, style: AppTypography.text1Regular),
        const Gap(16),
        const SectionLabel('Опись содержимого'),
        Text(d.contentDesc, style: AppTypography.text1Regular),
      ],
    );
  }
}
