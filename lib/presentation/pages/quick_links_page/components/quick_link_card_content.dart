import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';

class QuickLinkCardContent extends StatelessWidget {
  final QuickLinkModel quickLink;
  final Color textColor;

  const QuickLinkCardContent({
    super.key,
    required this.quickLink,
    this.textColor = AppColors.gray700,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quickLink.title,
                style: AppTypography.text1Medium,
              ),
              const SizedBox(height: 4),
              Text(
                quickLink.subtitle,
                style: AppTypography.text2Regular.copyWith(color: textColor),
              ),
            ],
          ),
        ),
        quickLink.icon != null
            ? SvgPicture.asset(quickLink.icon!, width: 24, height: 24)
            : const SizedBox.shrink(),
      ],
    );
  }
}
