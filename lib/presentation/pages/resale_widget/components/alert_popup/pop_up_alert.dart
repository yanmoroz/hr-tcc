import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hr_tcc/presentation/pages/resale_widget/components/alert_popup/alert_manager.dart';

class PopUpAlert {
  static Future<void> showAlert(
    BuildContext context,
    AlertPosition position,
    Widget contentWidet, {
    int duratioMmilliseconds = 1000,
  }) async {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // Use a simple TickerProvider implementation
    final tickerProvider = _SimpleTickerProvider();
    final animationController = AnimationController(
      duration: Duration(milliseconds: duratioMmilliseconds),
      vsync: tickerProvider,
    );

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    overlayEntry = OverlayEntry(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final visibleInset = mediaQuery.padding.top + 16;
        final bottomInset = mediaQuery.padding.bottom + 70 + 16;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final slideValue = animation.value;

            final double? top =
                position == AlertPosition.top
                    ? lerpDouble(-100, visibleInset, slideValue)
                    : null;
            final double? bottom =
                position == AlertPosition.bottom
                    ? lerpDouble(-100, bottomInset, slideValue)
                    : null;

            return Positioned(
              top: top,
              bottom: bottom,
              left: 16,
              right: 16,
              child: IgnorePointer(
                ignoring: false,
                child: Material(color: Colors.transparent, child: child),
              ),
            );
          },
          child: contentWidet,
        );
      },
    );

    overlay.insert(overlayEntry);
    await animationController.forward();
    await Future.delayed(Duration(milliseconds: duratioMmilliseconds));
    await animationController.reverse();
    overlayEntry.remove();
    animationController.dispose();
  }
}

class _SimpleTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
