import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Dialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            insetPadding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 19, 16, 20),
                  child: Column(
                    children: [
                      Text(
                        'Хотите выйти?',
                        style: AppTypography.title4Semibold,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Для повторной авторизации\nнеобходимо будет ввести логин\nи пароль',
                        style: AppTypography.text2Regular,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: AppColors.gray500),
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: onCancel,
                          child: Text(
                            'Отменить',
                            style: AppTypography.text1Regular.copyWith(
                              color: AppColors.blue300,
                            ),
                          ),
                        ),
                      ),
                      Container(width: 1, color: AppColors.gray500),
                      Expanded(
                        child: TextButton(
                          onPressed: onConfirm,
                          child: Text(
                            'Выйти',
                            style: AppTypography.text1Regular.copyWith(
                              color: AppColors.red500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
