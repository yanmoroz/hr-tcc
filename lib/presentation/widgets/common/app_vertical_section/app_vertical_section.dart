import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class VerticalSection extends StatelessWidget {
  final String? title;
  final String? moreButtonText;
  final VoidCallback? onSeeAll;
  final List<Widget> cards;
  final EdgeInsets padding;

  const VerticalSection({
    super.key,
    this.title,
    this.moreButtonText,
    required this.cards,
    this.onSeeAll,
    this.padding = const EdgeInsets.only(top: 24, left: 16, right: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title ?? '',
                  style: AppTypography.text1Semibold
                ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    moreButtonText ?? '',
                    style: AppTypography.openSectionButtonStyle,
                  ),
                ),
            ],
          ),
          if (title != null || onSeeAll != null) const SizedBox(height: 16),
          // Список карточек
          Column(
            children:
                cards.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  final isLast = index == cards.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                    child: card,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
