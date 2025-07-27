import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/resale_widget/components/components.dart';

class ResailDetailBookingCell extends StatelessWidget {
  final ResailDetailBookingCellModel model;

  const ResailDetailBookingCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${model.dateTime.day.toString().padLeft(2, '0')}.${model.dateTime.month.toString().padLeft(2, '0')}.${model.dateTime.year} в ${model.dateTime.hour.toString().padLeft(2, '0')}:${model.dateTime.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OnSaleBadge(model: model.badgeModel),
              const Spacer(),
              Text(
                formattedDate,
                style: AppTypography.caption2Medium.copyWith(
                  color: AppColors.gray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(model.namePerson, style: AppTypography.text2Regular),
        ],
      ),
    );
  }
}
