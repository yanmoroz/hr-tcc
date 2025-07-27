import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/presentation/pages/requests/components/section_label.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class DeliveryDatesSection extends StatelessWidget {
  final CourierRequestDetails details;
  const DeliveryDatesSection({super.key, required this.details});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final d = details;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Сроки доставки', style: AppTypography.title3Bold),
        const Gap(12),
        const SectionLabel('Срочность'),
        Text(d.priority, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Срок'),
        Text(_formatDate(d.deadline), style: AppTypography.text1Regular),
      ],
    );
  }
}
