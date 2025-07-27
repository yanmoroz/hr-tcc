import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AppHorizontalSection extends StatelessWidget {
  final String title;
  final String moreButtonText;
  final VoidCallback? onSeeAll;
  final List<Widget> cards;

  const AppHorizontalSection({
    super.key,
    required this.title,
    required this.moreButtonText,
    required this.cards,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок и кнопка
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.text1Semibold),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    moreButtonText,
                    style: AppTypography.text2Regular.copyWith(
                      color: AppColors.blue700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Все управление шириной внутри карточек
          Wrap(spacing: 8, runSpacing: 8, children: cards),
        ],
      ),
    );
  }
}
