import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class CommentSection<B extends StateStreamable<S>, S> extends StatelessWidget {
  final TextEditingController commentController;
  final FocusNode? focusNode;
  final Map<dynamic, String?> errors;
  final dynamic addCommentFieldKey;
  final dynamic commentFieldKey;
  final String switchLabel;
  final void Function(dynamic field, dynamic value) onFieldChanged;
  final bool Function(S state, dynamic addCommentFieldKey) addCommentSelector;
  final String Function(S state, dynamic commentFieldKey) commentSelector;

  const CommentSection({
    super.key,
    required this.commentController,
    this.focusNode,
    required this.errors,
    required this.addCommentFieldKey,
    required this.commentFieldKey,
    required this.switchLabel,
    required this.onFieldChanged,
    required this.addCommentSelector,
    required this.commentSelector,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        final addComment = addCommentSelector(state, addCommentFieldKey);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  switchLabel,
                  style: AppTypography.text1Medium.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Spacer(),
                AppSwitch(
                  value: addComment,
                  onChanged: (v) => onFieldChanged(addCommentFieldKey, v),
                ),
              ],
            ),
            if (addComment) ...[
              const Gap(8),
              AppTextArea(
                hint: 'Комментарий',
                controller: commentController,
                focusNode: focusNode,
                onChanged: (v) => onFieldChanged(commentFieldKey, v),
                errorText: errors[commentFieldKey],
              ),
            ],
          ],
        );
      },
    );
  }
}
