import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/app_colors.dart';

class AppFlostingBottomBar extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AppFlostingBottomBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 50),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.bottomShadowColor,
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
