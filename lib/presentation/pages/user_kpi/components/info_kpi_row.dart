import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class InfoKpiRow extends StatelessWidget {
  final String title;
  final String weight;
  final String fact;
  final String result;
  final bool isFirst;
  final bool isLast;

  const InfoKpiRow({
    super.key,
    required this.title,
    required this.weight,
    required this.fact,
    required this.result,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle) ...[
          SizedBox(height: isFirst ? 0 : 16),
          Text(title, style: AppTypography.text2Medium),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            _buildSegment('Вес ', weight, TextAlign.left, flex: 3),
            _buildDivider(),
            _buildSegment('Факт ', fact, TextAlign.center, flex: 3),
            _buildDivider(),
            _buildSegment('Расчет КПЭ ', result, TextAlign.right, flex: 4),
          ],
        ),
      ],
    );
  }

  Widget _buildSegment(
    String label,
    String value,
    TextAlign align, {
    required int flex,
  }) {
    return Flexible(
      fit: FlexFit.tight,
      flex: flex,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label,
              style: AppTypography.text2Regular.copyWith(
                color: AppColors.gray700,
              ),
            ),
            TextSpan(text: value, style: AppTypography.text2Semibold),
          ],
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: align,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '|',
        style: AppTypography.text2Regular.copyWith(color: AppColors.gray200),
      ),
    );
  }
}
