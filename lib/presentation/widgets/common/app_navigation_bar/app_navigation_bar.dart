import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final VoidCallback? onLeft;
  final String? leftIconAsset;
  final VoidCallback? onRight;
  final String? rightIconAsset;
  final Color? backgroundColor;
  final double height;

  const AppNavigationBar({
    super.key,
    required this.title,
    this.subTitle,
    this.leftIconAsset,
    this.onLeft,
    this.rightIconAsset,
    this.onRight,
    this.backgroundColor = AppColors.white,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading:
          leftIconAsset != null
              ? IconButton(
                onPressed: onLeft ?? () => context.pop(),
                icon: SvgPicture.asset(
                  leftIconAsset ?? Assets.icons.navigationBar.back.path,
                  width: 24,
                  height: 24,
                ),
              )
              : null,
      title: Column(
        children: [
          Text(title, style: AppTypography.title4Bold),
          if (subTitle != null)
            Text(
              subTitle ?? '',
              style: AppTypography.text2Regular.copyWith(
                color: AppColors.gray700,
              ),
            ),
        ],
      ),
      centerTitle: true,
      actions:
          rightIconAsset != null
              ? [
                IconButton(
                  onPressed: onRight,
                  icon: SvgPicture.asset(
                    rightIconAsset ?? Assets.icons.navigationBar.exit.path,
                    width: 24,
                    height: 24,
                  ),
                ),
              ]
              : [],
      toolbarHeight: height,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
