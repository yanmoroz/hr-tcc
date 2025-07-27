import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.text2Regular.copyWith(color: AppColors.gray500),
    );
  }
}
