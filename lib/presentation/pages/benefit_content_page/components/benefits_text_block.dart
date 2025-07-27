import 'package:flutter/material.dart';

class BenefitsTextBlock extends StatelessWidget {
  final String title;
  final String body;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final double spacing;

  const BenefitsTextBlock({
    super.key,
    required this.title,
    required this.body,
    required this.titleStyle,
    required this.bodyStyle,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        SizedBox(height: spacing),
        Text(
          body,
          style: bodyStyle,
        ),
      ],
    );
  }
}
