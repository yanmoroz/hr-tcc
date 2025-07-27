import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class ContactLink extends StatelessWidget {
  final String mainText;
  final String? subText;
  final VoidCallback onTap;

  const ContactLink({
    super.key,
    required this.mainText,
    this.subText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              children: [
                Text(
                  mainText,
                  style: AppTypography.text2Regular.copyWith(
                    color: AppColors.blue500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                if (subText != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    subText!,
                    style: AppTypography.text2Regular.copyWith(
                      color: AppColors.gray700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
