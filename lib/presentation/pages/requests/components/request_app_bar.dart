import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class RequestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onClose;
  final List<Widget>? actions;

  const RequestAppBar({
    super.key,
    required this.title,
    this.onClose,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTypography.title4Bold.copyWith(color: AppColors.black),
      ),
      centerTitle: true,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
      actions: [
        ...?actions,
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose ?? () => context.pop(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
