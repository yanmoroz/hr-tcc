import 'package:flutter/material.dart';
import 'package:hr_tcc/presentation/pages/resale_widget/components/components.dart';

enum AlertPosition { top, bottom }

class AlertManager {
  static bool _isShowing = false;
  static String? _lastKey;
  static DateTime? _lastShownTime;

  static Future<void> show(
    BuildContext context,
    String uniqueKey,
    AlertPosition position,
    Widget contentWidget,
  ) async {
    final now = DateTime.now();

    if (_isShowing) return;
    if (_lastKey == uniqueKey &&
        now.difference(_lastShownTime ?? now).inSeconds < 1) {
      return;
    }

    _isShowing = true;
    _lastKey = uniqueKey;
    _lastShownTime = now;

    try {
      await PopUpAlert.showAlert(context, position, contentWidget);
    } finally {
      _isShowing = false;
    }
  }
}