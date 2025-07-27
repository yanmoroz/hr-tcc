import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';

import '../../../widgets/common/common.dart';

class RequestCreationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const RequestCreationAppBar({super.key, required this.title});

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
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.gray700, size: 24),
          onPressed: () async {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder:
                  (ctx) => AppAlertDialog(
                    title: 'Прекратить создание заявки?',
                    content: '',
                    actionsOrientation: DialogActionsOrientation.vertical,
                    actions: [
                      DialogAction(
                        label: 'Отмена',
                        type: DialogActionType.cancel,
                        onPressed: () => context.pop(false),
                      ),
                      DialogAction(
                        label: 'Прекратить',
                        type: DialogActionType.confirm,
                        onPressed: () => context.pop(true),
                      ),
                    ],
                  ),
            );
            if (shouldExit == true && context.mounted) {
              context.pop();
              if (context.canPop()) {
                context.pop();
              }
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
