import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

// TODO: Reuse some common button widget?
class FinishButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  const FinishButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.blue700 : AppColors.blue200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
      ),
      child: Text(
        text,
        style: AppTypography.button1Medium.copyWith(color: AppColors.white),
      ),
    );
  }
}
