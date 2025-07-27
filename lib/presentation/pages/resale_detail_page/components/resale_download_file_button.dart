import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/app_colors.dart';
import 'package:hr_tcc/config/themes/app_typography.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class ResaleDownloadFileButton extends StatelessWidget {
  final String fileName;
  final VoidCallback onTap;

  const ResaleDownloadFileButton({
    super.key,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.gray100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.icons.resale.downloadIcon.svg(width: 24, height: 24),
              const SizedBox(width: 12),
              Text(fileName, style: AppTypography.text2Medium),
            ],
          ),
        ),
      ),
    );
  }
}
