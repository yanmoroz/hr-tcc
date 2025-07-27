import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class AppResaleLockButton extends StatelessWidget {
  final bool isLocked;
  final VoidCallback onPressed;
  final double height;
  final TextStyle textStyle;
  final double borderRadius;

  const AppResaleLockButton({
    super.key,
    required this.isLocked,
    required this.onPressed,
    required this.height,
    required this.textStyle,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isLocked ? AppColors.white : AppColors.blue700,
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: const BorderSide(color: AppColors.gray500, width: 1),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isLocked
                  ? Assets.icons.resalePage.closedLockPage.path
                  : Assets.icons.resalePage.openLockPage.path,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isLocked ? 'Снять бронь' : 'Забронировать',
              style: textStyle.copyWith(
                color: isLocked ? AppColors.black : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
