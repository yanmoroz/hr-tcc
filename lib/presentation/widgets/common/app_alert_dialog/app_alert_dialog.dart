import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

enum DialogActionsOrientation { vertical, horizontal }

enum DialogActionType { cancel, confirm, other }

class DialogAction {
  final String label;
  final VoidCallback onPressed;
  final DialogActionType type;

  DialogAction({
    required this.label,
    required this.onPressed,
    this.type = DialogActionType.other,
  });
}

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<DialogAction> actions;
  final DialogActionsOrientation actionsOrientation;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.actionsOrientation = DialogActionsOrientation.horizontal,
  });

  static final TextStyle _dialogContentStyle = AppTypography.text1Regular
      .copyWith(color: AppColors.black);
  static final TextStyle _dialogTitleStyle = AppTypography.title4Semibold
      .copyWith(color: AppColors.black);
  static final TextStyle _dialogActionStyle = AppTypography.text1Regular
      .copyWith(color: AppColors.red500);
  static final TextStyle _dialogCancelStyle = AppTypography.text1Regular
      .copyWith(color: AppColors.blue300);

  @override
  Widget build(BuildContext context) {
    final isVertical = actionsOrientation == DialogActionsOrientation.vertical;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: AppColors.gray100,
        title: _buildTitleAndContent(),
        contentPadding: const EdgeInsets.only(
          top: 0,
        ), // Чтобы не было лишних отступов
        content: null,
        actionsPadding: EdgeInsets.zero,
        actions: [_buildActionsWithDividers(actions, isVertical: isVertical)],
      ),
    );
  }

  Widget _buildTitleAndContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, textAlign: TextAlign.center, style: _dialogTitleStyle),
        if (content.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            content,
            textAlign: TextAlign.center,
            style: _dialogContentStyle,
          ),
        ],
      ],
    );
  }

  Widget _buildActionsWithDividers(
    List<DialogAction> actions, {
    required bool isVertical,
  }) {
    final List<Widget> children = [];

    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      final isCancel = action.type == DialogActionType.cancel;
      final textStyle = isCancel ? _dialogCancelStyle : _dialogActionStyle;

      // В горизонтальном режиме используем Expanded, в вертикальном — нет
      final button =
          isVertical
              ? InkWell(
                onTap: action.onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    action.label,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                ),
              )
              : Expanded(
                child: InkWell(
                  onTap: action.onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      action.label,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                ),
              );

      children.add(button);

      // Добавляем разделитель между кнопками, кроме последней
      if (i < actions.length - 1) {
        children.add(
          isVertical
              ? const DividerWidget(
                isVertical: false,
              ) // горизонтальная линия между кнопками в колонке
              : const DividerWidget(
                isVertical: true,
              ), // вертикальная линия между кнопками в строке
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DividerWidget(isVertical: false), // Горизонтальная линия сверху
        isVertical
            ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            )
            : Row(children: children),
      ],
    );
  }
}

class DividerWidget extends StatelessWidget {
  final bool isVertical;

  const DividerWidget({super.key, required this.isVertical});

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? Container(width: 0.5, height: 50, color: AppColors.gray500)
        : const Divider(height: 1, thickness: 0.5, color: AppColors.gray500);
  }
}
