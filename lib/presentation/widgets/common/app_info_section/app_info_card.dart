import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AppInfoCard extends StatelessWidget {
  final List<Widget> children;
  final Color? color;
  final Gradient? gradient;
  final Color shadowColor;
  final String? title;
  final EdgeInsetsGeometry padding;

  const AppInfoCard({
    super.key,
    required this.children,
    this.color,
    this.gradient,
    required this.shadowColor,
    this.title,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title ?? '',
              style: AppTypography.text2Regular
            ),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    );
  }
}
