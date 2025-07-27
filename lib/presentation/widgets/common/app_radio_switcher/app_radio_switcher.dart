import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AppRadioSwitcherItem<T> {
  final T value;
  final String label;
  AppRadioSwitcherItem({required this.value, required this.label});
}

class AppRadioSwitcher<T> extends StatelessWidget {
  final List<AppRadioSwitcherItem<T>> items;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const AppRadioSwitcher({
    super.key,
    required this.items,
    required this.groupValue,
    required this.onChanged,
    this.padding,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            RadioListTile<T>(
              value: items[i].value,
              groupValue: groupValue,
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              title: Text(items[i].label),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              activeColor: AppColors.blue700,
            ),
            if (i < items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(height: 1, color: AppColors.white),
              ),
          ],
        ],
      ),
    );
  }
}
