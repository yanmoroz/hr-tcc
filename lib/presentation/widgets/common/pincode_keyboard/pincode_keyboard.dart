import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

enum PincodeKeyboardType {
  setup, // Only 0 in bottom row
  pinOnly, // "Password login", 0, empty/backspace
  pinWithFaceID, // "Password login", 0, FaceID icon/backspace
  pinWithTouchID, // "Password login", 0, TouchID icon/backspace
}

class PincodeKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final PincodeKeyboardType type;
  final VoidCallback? onBiometricPressed;
  final VoidCallback? onPasswordLoginPressed;
  final bool showBackspace;
  static const _animationDuration = Duration(milliseconds: 200);

  const PincodeKeyboard({
    super.key,
    required this.onKeyPressed,
    this.type = PincodeKeyboardType.pinOnly,
    this.onBiometricPressed,
    this.onPasswordLoginPressed,
    this.showBackspace = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const Gap(16),
        _buildRow(['4', '5', '6']),
        const Gap(16),
        _buildRow(['7', '8', '9']),
        const Gap(16),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildRow(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((value) => _buildKey(value)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildLeftButton(), _buildKey('0'), _buildRightButton()],
    );
  }

  Widget _buildLeftButton() {
    if (type == PincodeKeyboardType.setup) {
      return const SizedBox(width: 80, height: 80);
    }

    return SizedBox(
      width: 80,
      height: 80,
      child: AnimatedSwitcher(
        duration: _animationDuration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: TextButton(
          key: const ValueKey('password_login'),
          onPressed: onPasswordLoginPressed,
          child: const Text(
            'Вход по\nпаролю',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildRightButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: AnimatedSwitcher(
        duration: _animationDuration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: _buildRightButtonContent(),
      ),
    );
  }

  Widget _buildRightButtonContent() {
    if (showBackspace) {
      return IconButton(
        key: const ValueKey('backspace'),
        icon: Assets.icons.keyboard.backspace.svg(),
        onPressed: () => onKeyPressed('backspace'),
      );
    }

    if (type == PincodeKeyboardType.setup) {
      return const SizedBox(key: ValueKey('empty'), width: 80, height: 80);
    }

    switch (type) {
      case PincodeKeyboardType.pinWithFaceID:
        return IconButton(
          key: const ValueKey('face_id'),
          icon: const Icon(Icons.face, size: 32),
          onPressed: onBiometricPressed,
        );
      case PincodeKeyboardType.pinWithTouchID:
        return IconButton(
          key: const ValueKey('touch_id'),
          icon: const Icon(Icons.fingerprint, size: 32),
          onPressed: onBiometricPressed,
        );
      default:
        return const SizedBox(key: ValueKey('empty'), width: 80, height: 80);
    }
  }

  Widget _buildKey(String value) {
    if (value.isEmpty) {
      return const SizedBox(width: 80, height: 80);
    }

    return _AnimatedKeyButton(value: value, onPressed: onKeyPressed);
  }
}

class _AnimatedKeyButton extends StatefulWidget {
  final String value;
  final Function(String) onPressed;

  const _AnimatedKeyButton({required this.value, required this.onPressed});

  @override
  State<_AnimatedKeyButton> createState() => _AnimatedKeyButtonState();
}

class _AnimatedKeyButtonState extends State<_AnimatedKeyButton> {
  bool _isPressed = false;
  static const _animationDuration = Duration(milliseconds: 150);

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed(widget.value);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                duration: _animationDuration,
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _isPressed
                          ? AppColors.gray100
                          : AppColors.gray100.withValues(alpha: 0),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
