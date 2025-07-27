import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../widgets/common/common.dart';
import 'components.dart';

class TargetKpiSection extends StatelessWidget {
  final KpiPeriodGroup group;
  final Color cardColor;
  final Color shadowColor;

  const TargetKpiSection({
    super.key,
    required this.group,
    required this.cardColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppSectionWithCard(
      title: 'Целевые показатели',
      cards:
          group.kpiCards.map((card) {
            final entries =
                <({String title, String weight, String fact, String result})>[];

            for (final indicator in card.indicators) {
              for (final metric in indicator.metrics) {
                entries.add((
                  title: indicator.title,
                  weight: metric.weight,
                  fact: metric.fact,
                  result: metric.result,
                ));
              }
            }

            return AppInfoCard(
              title: card.title,
              color: cardColor,
              shadowColor: shadowColor,
              children: List.generate(entries.length, (index) {
                final isFirst = index == 0;
                final isLast = index == entries.length - 1;
                final entry = entries[index];

                return InfoKpiRow(
                  isFirst: isFirst,
                  isLast: isLast,
                  title: entry.title,
                  weight: entry.weight,
                  fact: entry.fact,
                  result: entry.result,
                );
              }),
            );
          }).toList(),
    );
  }
}
