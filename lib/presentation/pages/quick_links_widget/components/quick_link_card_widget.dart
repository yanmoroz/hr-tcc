import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';

class QuickLinkCardWidget extends StatelessWidget {
  final QuickLinkModel link;
  final Color shadowColor;
  final Color textColor;

  const QuickLinkCardWidget({
    super.key,
    required this.link,
    this.shadowColor = AppColors.cardShadowColor,
    this.textColor = AppColors.gray700,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            width: 62,
            height: 60,
            decoration: BoxDecoration(
              color:
                  link.backgroundColor ??
                  AppColors
                      .quickLinksConfluenceJiraBackgroundColor, // Дефолтный вариант
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child:
                  link.icon != null
                      ? SvgPicture.asset(
                        link.icon!,
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      )
                      : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            link.title,
            style: AppTypography.caption2Medium.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
