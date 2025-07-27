import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AppSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const AppSearchField({
    required this.hint,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.gray100,
        prefixIconColor: AppColors.gray700,
        hintStyle: AppTypography.text1Regular.copyWith(
          color: AppColors.gray500,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
