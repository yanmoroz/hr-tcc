import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AppImageWithBorder extends StatelessWidget {
  final String imageUrl;

  final double width;
  final double height;
  final double borderRadius;

  final Color borderColor;
  final double borderWidth;
  final double borderPadding;
  final double imageRadius;

  const AppImageWithBorder({
    super.key,
    required this.imageUrl,
    this.width = 40,
    this.height = 40,
    this.borderRadius = 12,
    this.borderColor = AppColors.blue700,
    this.borderWidth = 1.0,
    this.borderPadding = 3,
    this.imageRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(imageRadius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            errorWidget:
                (context, url, error) => Icon(Icons.person, size: width),
          ),
        ),
      ),
    );
  }
}