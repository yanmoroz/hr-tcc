import 'dart:ui';

class MoreCardModel {
  final MoreCardId id;
  final String title;
  final String? subTitle;
  final String? badgeTitle;
  final Color? backgroundBageColor;

  const MoreCardModel({
    required this.id,
    required this.title,
    this.subTitle,
    this.badgeTitle,
    this.backgroundBageColor,
  });

  MoreCardModel copyWith({
    String? title,
    String? subTitle,
    String? badgeTitle,
    Color? backgroundBageColor,
  }) {
    return MoreCardModel(
      id: id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      badgeTitle: badgeTitle ?? this.badgeTitle,
      backgroundBageColor: backgroundBageColor ?? this.backgroundBageColor,
    );
  }
}

enum MoreCardId {
  violations,
  quickLinks,
  resale,
  polls,
  news,
  benefits,
  addressBook,
}