import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class AdressBookAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fullName;
  final double size;

  const AdressBookAvatar({
    super.key,
    required this.fullName,
    this.imageUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return AppImageWithBorder(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        borderColor: AppColors.transparent,
        borderWidth: 0,
        borderPadding: 0,
      );
    } else {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.blue700,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _getInitials(fullName),
          style: AppTypography.text1Semibold.copyWith(color: AppColors.white),
        ),
      );
    }
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final lastNameInitial =
          parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
      final firstNameInitial =
          parts[1].isNotEmpty ? parts[1][0].toUpperCase() : '';
      return '$firstNameInitial$lastNameInitial';
    }

    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '';
  }
}
