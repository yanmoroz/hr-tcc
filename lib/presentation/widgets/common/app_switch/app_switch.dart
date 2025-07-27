import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

enum AppSwitchLabelPosition { left, right }

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final bool showLabel;
  final Color activeColor;
  final Color? inactiveColor;
  final Color activeTrackColor;
  final Color? inactiveThumbColor;
  final Color hoverColor;
  final Color focusColor;
  final Color? overlayColor;
  final Color? thumbColor;
  final Color? trackColor;
  final WidgetStateProperty<double?>? trackOutlineWidth;
  final WidgetStateProperty<Color?>? materialThumbColor;
  final WidgetStateProperty<Color?>? materialTrackColor;
  final WidgetStateProperty<Color?>? materialOverlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool autofocus;
  final AppSwitchLabelPosition labelPosition;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.showLabel = true,
    this.activeColor = AppColors.white,
    this.inactiveColor = AppColors.gray500,
    this.activeTrackColor = AppColors.blue700,
    this.inactiveThumbColor = AppColors.white,
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.overlayColor,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineWidth = const WidgetStatePropertyAll(0.0),
    this.materialThumbColor,
    this.materialTrackColor,
    this.materialOverlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.autofocus = false,
    this.labelPosition = AppSwitchLabelPosition.left,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      inactiveTrackColor: inactiveColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      trackOutlineWidth: trackOutlineWidth,
      hoverColor: hoverColor,
      focusColor: focusColor,
      overlayColor:
          overlayColor != null ? WidgetStateProperty.all(overlayColor) : null,
      thumbColor:
          thumbColor != null
              ? WidgetStateProperty.all(thumbColor)
              : materialThumbColor,
      trackColor:
          trackColor != null
              ? WidgetStateProperty.all(trackColor)
              : materialTrackColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      autofocus: autofocus,
    );
    final labelWidget =
        (showLabel && label != null)
            ? Text(
              label!,
              style: AppTypography.text1Medium.copyWith(color: AppColors.black),
            )
            : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          labelPosition == AppSwitchLabelPosition.left
              ? [if (labelWidget != null) labelWidget, switchWidget]
              : [switchWidget, if (labelWidget != null) labelWidget],
    );
  }
}
