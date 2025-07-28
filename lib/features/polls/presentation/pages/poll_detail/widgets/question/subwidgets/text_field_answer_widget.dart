import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class TextFieldAnswerWidget extends StatelessWidget {
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const TextFieldAnswerWidget({
    super.key,
    this.hint = 'Ваш ответ',
    this.maxLines = 3,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray500, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray500, width: 1),
        ),
        labelStyle: AppTypography.text1Regular,
        helperStyle: AppTypography.text1Regular,
      ),
    );
  }
}
