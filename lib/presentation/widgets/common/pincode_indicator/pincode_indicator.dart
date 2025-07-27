import 'dart:math';
import 'package:flutter/material.dart';

class PincodeIndicator extends StatefulWidget {
  final int length;
  final int enteredLength;
  final bool hasError;

  const PincodeIndicator({
    super.key,
    required this.length,
    required this.enteredLength,
    this.hasError = false,
  });

  @override
  State<PincodeIndicator> createState() => _PincodeIndicatorState();
}

class _PincodeIndicatorState extends State<PincodeIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final AnimationController _errorColorController;
  late final Animation<double> _shakeAnimation;
  late final Animation<Color?> _colorAnimation;
  final List<bool> _dotAnimationStates = [];
  bool _wasError = false;

  static const Color _activeColor = Color(0xFF0A3899);
  static const Color _errorColor = Color(0xFFEE0019);
  static const Color _inactiveColor = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _errorColorController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).chain(CurveTween(curve: ShakeCurve())).animate(_shakeController);

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: _activeColor, end: _errorColor),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: _errorColor, end: _inactiveColor),
      ),
    ]).animate(
      CurvedAnimation(parent: _errorColorController, curve: Curves.easeInOut),
    );

    _dotAnimationStates.addAll(List.generate(widget.length, (index) => false));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _errorColorController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PincodeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Запускаем анимацию при появлении ошибки
    if (!oldWidget.hasError && widget.hasError) {
      _wasError = true;
      _shakeController.forward().then((_) => _shakeController.reset());
      _errorColorController
        ..reset()
        ..forward();
    }

    // Сбрасываем анимацию цвета при начале нового ввода после ошибки
    if (_wasError && widget.enteredLength == 1) {
      _wasError = false;
      _errorColorController.reset();
    }

    // Trigger animation for new dots
    if (widget.enteredLength > oldWidget.enteredLength) {
      setState(() {
        _dotAnimationStates[oldWidget.enteredLength] = true;
      });
    }
  }

  Color _getDotColor(int index) {
    if (index >= widget.enteredLength) {
      return _inactiveColor;
    }

    if (widget.hasError) {
      return _colorAnimation.value ?? _errorColor;
    }

    if (_wasError && _errorColorController.value > 0) {
      return _inactiveColor;
    }

    return _activeColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnimation, _colorAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.length,
              (index) => TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuad, // Безопасная кривая
                tween: Tween<double>(
                  begin: 1.0,
                  end: _dotAnimationStates[index] ? 1.0 : 0.0,
                ),
                onEnd: () {
                  if (_dotAnimationStates[index]) {
                    setState(() {
                      _dotAnimationStates[index] = false;
                    });
                  }
                },
                builder:
                    (context, scale, child) => Transform.scale(
                      scale:
                          index < widget.enteredLength
                              ? 1.0 + (scale.clamp(0.0, 1.0) * 0.4)
                              : 1.0,
                      child: Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getDotColor(index),
                        ),
                      ),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    if (t == 0.0) return 0.0;
    if (t == 1.0) return 1.0;
    final double val = sin(t * 3 * pi) * (1 - t);
    return (val + 1) / 2;
  }
}
