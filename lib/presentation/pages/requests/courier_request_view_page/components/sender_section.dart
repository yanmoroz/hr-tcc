import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/presentation/pages/requests/components/section_label.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class SenderSection extends StatelessWidget {
  final CourierRequestDetails details;
  const SenderSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final d = details;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('От кого доставка', style: AppTypography.title3Bold),
        const Gap(12),
        const SectionLabel('Юридическое лицо'),
        Text(d.company, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Подразделение'),
        Text(d.department, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Контактный телефон'),
        Text(d.contactPhone, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Цель поездки'),
        Text(d.tripGoal, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Офис'),
        Text(d.office, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Руководитель'),
        Text(d.manager, style: AppTypography.text1Regular),
      ],
    );
  }
}
