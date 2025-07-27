import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../widgets/common/common.dart';

class PlanValuesSection extends StatelessWidget {
  final KpiPeriodGroup group;
  final Color cardColor;
  final Color shadowColor;
  final Color labelColor;

  const PlanValuesSection({
    super.key,
    required this.group,
    required this.cardColor,
    required this.shadowColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppSectionWithCard(
      title: 'Плановые значения',
      cards: [
        AppInfoCard(
          color: cardColor,
          shadowColor: shadowColor,
          children:
              group.planValues.asMap().entries.map((entry) {
                final isLast = entry.key == group.planValues.length - 1;
                final value = entry.value;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                  child: AppInfoRow(
                    label: value.label,
                    value: value.value,
                    labelColor: labelColor,
                    valueFontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
