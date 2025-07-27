import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/chat_page/components/components.dart';
import 'package:hr_tcc/presentation/pages/helpers/helpers.dart';
import 'package:intl/intl.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageModel message;
  final String currentUserId;
  final void Function(String) onFileTap;
  final VoidCallback? onReply;
  final VoidCallback? onLike;
  final String? replyToSenderName;
  final String? replyToMessageText;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.onFileTap,
    this.onReply,
    this.onLike,
    this.replyToSenderName,
    this.replyToMessageText,
  });

  String _formatFileSize(int? sizeBytes) {
    if (sizeBytes == null) return '';
    if (sizeBytes < 1024) {
      return '$sizeBytes Б';
    }
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} Кб';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} Мб';
  }

  @override
  Widget build(BuildContext context) {
    final isOwn = message.userId == currentUserId;
    final avatar = ChatMessageAvatar(
      avatarUrl: message.avatarUrl,
      initials: NameHelper.getInitials(message.senderName),
    );
    final messageBubble = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyToSenderName != null && replyToMessageText != null) ...[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 1, color: AppColors.blue700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'В ответ $replyToSenderName',
                            style: AppTypography.text2Medium.copyWith(
                              color: AppColors.blue700,
                            ),
                          ),
                          Text(
                            replyToMessageText ?? '',
                            style: AppTypography.caption2Medium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ],
          Text(message.senderName, style: AppTypography.text2Semibold),
          if (message.chatFileModels?.isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            for (int i = 0; i < (message.chatFileModels?.length ?? 0); i++) ...[
              if (message.chatFileModels?[i] != null) ...[
                GestureDetector(
                  onTap: () => onFileTap(message.chatFileModels?[i].filesUrl ?? ''),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.chat.chatFile.path,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.chatFileModels?[i].fileName ?? '',
                              style: AppTypography.text2Regular.copyWith(
                                color: AppColors.blue700,
                              ),
                            ),
                            Text(
                              _formatFileSize(message.chatFileModels?[i].fileSizeBytes),
                              style: AppTypography.caption2Medium.copyWith(
                                color: AppColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ],
          ],

          if (message.message.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(message.message, style: AppTypography.text2Regular),
            const SizedBox(height: 16),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm').format(message.date),
                style: AppTypography.caption3Medium.copyWith(
                  color: AppColors.gray700,
                ),
              ),
              const Spacer(),
              if (!isOwn) ...[
                GestureDetector(
                  onTap: onReply,
                  child: Text(
                    'Ответить',
                    style: AppTypography.text2Medium.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  message.likesCount.toString(),
                  style: AppTypography.text2Medium.copyWith(
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onLike,
                  child: SvgPicture.asset(
                    message.isLike
                        ? Assets.icons.chat.likePressed.path
                        : Assets.icons.chat.likeUnpressed.path,
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
    return Padding(
      padding:
          isOwn
              ? const EdgeInsets.only(left: 72)
              : const EdgeInsets.only(right: 72),
      child: Row(
        mainAxisAlignment:
            isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwn) ...[
            avatar,
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [messageBubble],
              ),
            ),
          ] else ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [messageBubble],
              ),
            ),
            const SizedBox(width: 8),
            avatar,
          ],
        ],
      ),
    );
  }
}
