import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/presentation/pages/requests/components/section_label.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class ReceiverSection extends StatelessWidget {
  final CourierRequestDetails details;
  const ReceiverSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final d = details;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Куда и кому доставить', style: AppTypography.title3Bold),
        const Gap(12),
        const SectionLabel('Наименование компании'),
        Text(d.companyName, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Адрес'),
        Text(d.address, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('ФИО'),
        Text(d.fio, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Телефон'),
        Text(d.phone, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Email'),
        Text(d.email, style: AppTypography.text1Regular),
        const Gap(8),
        const SectionLabel('Комментарий'),
        Text(d.comment, style: AppTypography.text1Regular),
      ],
    );
  }
}
