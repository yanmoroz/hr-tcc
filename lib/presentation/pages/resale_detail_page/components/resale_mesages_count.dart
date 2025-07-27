import 'package:flutter/material.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class ResaleMesagesCount extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const ResaleMesagesCount({super.key, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Assets.icons.resale.chat.svg(height: 24, width: 24),
            const SizedBox(width: 12),
            Text('$count'),
          ],
        ),
      ),
    );
  }
}
