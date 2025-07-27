import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';

class OnSaleBadge extends StatelessWidget {
  final OnSaleBadgeModel model;

  const OnSaleBadge({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: model.backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        model.text,
        style: AppTypography.caption2Medium.copyWith(color: model.textColor),
      ),
    );
  }
}