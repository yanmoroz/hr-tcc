import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, tertiary }

enum AppButtonSize { small, large }

class AppButton extends StatelessWidget {
  static const double _minButtonWidth = 120.0;
  static const double _smallButtonHeight = 40.0;
  static const double _largeButtonHeight = 52.0;
  static const double _borderRadius = 12.0;
  static const double _iconSize = 20.0;
  static const double _iconSpacing = 8.0;
  static const double _fontSize = 16.0;
  static const FontWeight _fontWeight = FontWeight.w500;
  static const Color _secondaryBorderColor = Color(0xFFBABABE);
  static const double _disabledStateOpacity = 0.5;
  static const double _hoverOpacity = 0.9;
  static const double _pressedOpacity = 0.8;

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? iconColor;
  final bool isDisabled;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconColor,
    this.isDisabled = false,
  });

  double get _buttonHeight => size == AppButtonSize.small ? _smallButtonHeight : _largeButtonHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _buildButton(context, theme);
  }

  Widget _buildButton(BuildContext context, ThemeData theme) {
    final buttonStyle = _getButtonStyle(context, theme);
    return _getButtonByVariant(buttonStyle, context);
  }

  ButtonStyle _getButtonStyle(BuildContext context, ThemeData theme) {
    final baseStyle = ButtonStyle(
      textStyle: WidgetStateProperty.all(const TextStyle(fontSize: _fontSize, fontWeight: _fontWeight)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius))),
      minimumSize: WidgetStateProperty.all(
        isFullWidth ? Size(MediaQuery.of(context).size.width, _buttonHeight) : Size(_minButtonWidth, _buttonHeight),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.black.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.black.withValues(alpha: 0.05);
        }
        return null;
      }),
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (isDisabled) {
              return theme.primaryColor.withValues(alpha: _disabledStateOpacity);
            }
            if (states.contains(WidgetState.pressed)) {
              return theme.primaryColor.withValues(alpha: _pressedOpacity);
            }
            if (states.contains(WidgetState.hovered)) {
              return theme.primaryColor.withValues(alpha: _hoverOpacity);
            }
            return theme.primaryColor;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        );
      case AppButtonVariant.secondary:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (isDisabled) {
              return Colors.black.withValues(alpha: _disabledStateOpacity);
            }
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withValues(alpha: _pressedOpacity);
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.black.withValues(alpha: _hoverOpacity);
            }
            return Colors.black;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            final color =
                isDisabled ? _secondaryBorderColor.withValues(alpha: _disabledStateOpacity) : _secondaryBorderColor;
            if (states.contains(WidgetState.pressed)) {
              return BorderSide(color: color.withValues(alpha: _pressedOpacity));
            }
            if (states.contains(WidgetState.hovered)) {
              return BorderSide(color: color.withValues(alpha: _hoverOpacity));
            }
            return BorderSide(color: color);
          }),
        );
      case AppButtonVariant.tertiary:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (isDisabled) {
              return theme.primaryColor.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.pressed)) {
              return theme.primaryColor.withValues(alpha: 0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return theme.primaryColor.withValues(alpha: 0.15);
            }
            return theme.primaryColor.withValues(alpha: 0.1);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (isDisabled) {
              return theme.primaryColor.withValues(alpha: _disabledStateOpacity);
            }
            return theme.primaryColor;
          }),
        );
    }
  }

  Widget _getButtonByVariant(ButtonStyle style, BuildContext context) {
    final buttonChild = _buildButtonChild(context);

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: style,
          child: buttonChild,
        );
      case AppButtonVariant.secondary:
      case AppButtonVariant.tertiary:
        return OutlinedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: style,
          child: buttonChild,
        );
    }
  }

  Widget _buildButtonChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: _iconSize, color: iconColor), const SizedBox(width: _iconSpacing)],
        Text(text),
      ],
    );
  }
}
