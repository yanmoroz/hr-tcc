import 'package:flutter/material.dart';

class AppInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final FontWeight labelFontWeight;
  final FontWeight valueFontWeight;

  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.labelColor,
    this.labelFontWeight = FontWeight.w400,
    this.valueFontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: labelColor, fontWeight: labelFontWeight),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: valueFontWeight),
            ),
          ),
        ],
      ),
    );
  }
}
