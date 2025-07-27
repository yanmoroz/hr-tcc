import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class EmployeeCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onRemove;

  const EmployeeCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 16, 0, 16),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.text1Medium),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: AppTypography.text2Regular.copyWith(
                        color: AppColors.gray700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Assets.icons.textField.closeCircleBlue.svg(
              width: 16,
              height: 16,
            ),
            onPressed: onRemove,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
