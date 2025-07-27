import 'package:flutter/material.dart';

// Custom Radio
class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
    this.size = 20,
    this.innerCircleSize = 12,
  });

  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double innerCircleSize;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _selected ? activeColor : inactiveColor,
            width: 2,
          ),
        ),
        child:
            _selected
                ? Center(
                  child: Container(
                    width: innerCircleSize,
                    height: innerCircleSize,
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
