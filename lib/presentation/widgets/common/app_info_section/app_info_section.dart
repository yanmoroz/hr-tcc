import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AppSectionWithCard extends StatelessWidget {
  final String title;
  final List<Widget> cards;

  const AppSectionWithCard({
    super.key,
    required this.title,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle) ...[
          Text(title, style: AppTypography.text1Semibold),
          const SizedBox(height: 16),
        ],
        ...cards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;
          final isLast = index == cards.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
            child: card,
          );
        }),
      ],
    );
  }
}
