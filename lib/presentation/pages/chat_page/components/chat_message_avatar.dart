import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class ChatMessageAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String initials;
  final double size;

  const ChatMessageAvatar({
    super.key,
    required this.avatarUrl,
    required this.initials,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.blue700,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            initials,
            style: AppTypography.text2Semibold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      );
    }
  }
}
