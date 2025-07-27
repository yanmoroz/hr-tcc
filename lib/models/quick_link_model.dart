// Модель быстрой ссылки

import 'dart:ui';

class QuickLinkModel {
  final String title;
  final String subtitle;
  final String? icon;
  final String url;
  final Color? backgroundColor;

  const QuickLinkModel({
    required this.title,
    required this.subtitle,
    this.icon,
    required this.url,
    this.backgroundColor,
  });
}
