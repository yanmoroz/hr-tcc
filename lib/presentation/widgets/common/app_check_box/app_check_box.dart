import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color activeColor;
  final Color checkColor;
  final Color borderColor;
  final bool enabled;

  const AppCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24.0,
    this.activeColor = const Color(0xFF0A369D), // Deep blue
    this.checkColor = Colors.white,
    this.borderColor = const Color(0xFF0A369D),
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled;
    final disabledColor = Colors.grey.shade400;

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color:
              value
                  ? (isDisabled ? disabledColor : activeColor)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDisabled ? disabledColor : borderColor,
            width: 2,
          ),
        ),
        child:
            value
                ? Center(
                  child: Icon(
                    Icons.check,
                    size: size * 0.7,
                    color: isDisabled ? Colors.white : checkColor,
                  ),
                )
                : null,
      ),
    );
  }
}
