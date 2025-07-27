import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class BenefitsPrefixLinkText extends StatelessWidget {
  final String prefix;
  final String text;
  final VoidCallback onTap;

  const BenefitsPrefixLinkText({
    super.key,
    this.prefix = '•',
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$prefix ',
              style: AppTypography.text1Regular.copyWith(
                color: AppColors.white,
              ),
            ),
            TextSpan(
              text: text,
              style: AppTypography.text1Regular.copyWith(
                color: AppColors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
