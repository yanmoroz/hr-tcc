import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

// Обертка контента, блюр + DraggableScrollableSheet
class AppModalSheetWrapper extends StatelessWidget {
  const AppModalSheetWrapper({
    super.key,
    required this.child,
    required this.initFraction,
    required this.maxFraction,
    this.blur,
    this.barrier = const Color(0x4D000000),
  });

  final Widget child;
  final double initFraction;
  final double maxFraction;
  final ui.ImageFilter? blur;
  final Color barrier;

  @override
  Widget build(BuildContext context) {
    final ui.ImageFilter effBlur =
        blur ?? ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10);

    return Stack(
      children: [
        BackdropFilter(filter: effBlur, child: Container(color: barrier)),
        DraggableScrollableSheet(
          initialChildSize: initFraction,
          minChildSize: initFraction,
          maxChildSize: maxFraction,
          builder:
              (_, controller) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                clipBehavior: Clip.hardEdge,
                child: child,
              ),
        ),
      ],
    );
  }
}
