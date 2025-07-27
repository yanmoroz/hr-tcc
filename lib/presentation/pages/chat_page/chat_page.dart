import 'package:flutter/material.dart';
import 'package:hr_tcc/config/localise/localise.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/chat_page/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/pages/helpers/helpers.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class ChatPage extends StatefulWidget {
  final String title;
  final String subTitle;

  const ChatPage({super.key, required this.title, required this.subTitle});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatUserMentionModel> _filteredUsers = [];
  bool _showMentions = false;
  int? _mentionStartIdx;
  String? _lastMessageId;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTextChanged(String value) {
    final selection = _controller.selection.baseOffset;
    final text = value.substring(0, selection >= 0 ? selection : value.length);
    final atIdx = text.lastIndexOf('@');
    if (atIdx != -1 && (atIdx == 0 || text[atIdx - 1] == ' ')) {
      final query = text.substring(atIdx + 1).toLowerCase();
      _filteredUsers = context.read<ChatBloc>().searchUsersByQuery(query);
      setState(() {
        _showMentions = _filteredUsers.isNotEmpty;
        _mentionStartIdx = atIdx;
      });
    } else {
      setState(() {
        _showMentions = false;
        _mentionStartIdx = null;
      });
    }
  }

  void _onUserSelected(ChatUserMentionModel user) {
    final text = _controller.text;
    final selection = _controller.selection.baseOffset;
    if (_mentionStartIdx != null && (_mentionStartIdx ?? 0) < selection) {
      final before = text.substring(0, (_mentionStartIdx ?? 0) + 1);
      final after = text.substring(selection);
      final newText = '$before${user.name} $after';
      final newSelection = before.length + user.name.length + 1;
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newSelection),
      );
      setState(() {
        _showMentions = false;
        _mentionStartIdx = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final dayList = state.groupedMessagesByDay.entries.toList();
        // Автоскролл вниз при появлении нового сообщения
        final lastMsg = state.messages.isNotEmpty ? state.messages.last : null;
        if (lastMsg != null && lastMsg.id != _lastMessageId) {
          _lastMessageId = lastMsg.id;
          _scrollToBottom();
        }
        return Scaffold(
          backgroundColor: AppColors.gray200,
          appBar: AppNavigationBar(
            title: widget.title,
            subTitle: commentsIntl(state.messages.length),
          ),
          body: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                width: double.infinity,
                height: 42,
                color: Colors.white,
                child: Text(
                  widget.subTitle,
                  style: AppTypography.text2Regular.copyWith(
                    color: AppColors.gray700,
                  ),
                ),
              ),
              // Список сообщений с sticky header
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    for (final entry in dayList)
                      SliverStickyHeader(
                        header: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gray500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              entry.key,
                              style: AppTypography.caption2Medium.copyWith(
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Сообщения
                        sliver: SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final msg = entry.value[index];
                              String? replyToSenderName;
                              String? replyToMessageText;
                              if (msg.replyToId != null) {
                                try {
                                  final replyMsg = state.messages.firstWhere(
                                    (m) => m.id == msg.replyToId,
                                  );
                                  replyToSenderName = replyMsg.senderName;
                                  replyToMessageText = replyMsg.message;
                                } on Exception catch (_) {
                                  // Не найдено сообщение-оригинал
                                }
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ChatMessageWidget(
                                    message: msg,
                                    currentUserId: state.currentUserId,
                                    onFileTap: (fileUrl) {
                                      context.read<ChatBloc>().add(
                                        TapOnFileChat(fileUrl: fileUrl),
                                      );
                                    },
                                    onReply: () {
                                      context.read<ChatBloc>().add(
                                        ReplyToMessage(msg),
                                      );
                                    },
                                    onLike: () {
                                      context.read<ChatBloc>().add(
                                        ChatLikePressed(msg),
                                      );
                                    },
                                    replyToSenderName: replyToSenderName,
                                    replyToMessageText: replyToMessageText,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }, childCount: entry.value.length),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Показать список сотрудников которых нужно тегнуть
              if (_showMentions)
                Container(
                  width: double.infinity,
                  color: AppColors.white,
                  child: Material(
                    color: AppColors.white,
                    elevation: 4,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _onUserSelected(user),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  ChatMessageAvatar(
                                    avatarUrl: user.avatarLink,
                                    initials: NameHelper.getInitials(user.name),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      user.name,
                                      style: AppTypography.text2Medium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              // Поле ввода
              Container(
                color: Colors.white,
                child: ChatInputField(
                  replyTo: state.replyToMessage,
                  onCancelReply:
                      () => context.read<ChatBloc>().add(CancelReply()),
                  onSend: (text, files) {
                    context.read<ChatBloc>().add(
                      SendMessage(
                        text: text,
                        files: files,
                        replyTo: state.replyToMessage,
                      ),
                    );
                  },
                  controller: _controller,
                  onTextChanged: _onTextChanged,
                  showMentions: _showMentions,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
