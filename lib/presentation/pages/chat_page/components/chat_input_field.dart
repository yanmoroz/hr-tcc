import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/pages/chat_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputField extends StatefulWidget {
  final void Function(String text, List<PlatformFile> files) onSend;
  final dynamic replyTo;
  final VoidCallback? onCancelReply;
  final TextEditingController? controller;
  final ValueChanged<String>? onTextChanged;
  final bool showMentions;
  const ChatInputField({
    super.key,
    required this.onSend,
    this.replyTo,
    this.onCancelReply,
    this.controller,
    this.onTextChanged,
    this.showMentions = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _sending = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: true,
    );

    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      for (final file in result.files) {
        final extension = file.extension?.toLowerCase() ?? '';
        if (!mounted) return;
        context.read<AppFileGridBloc>().add(
          AddFileWithPath(
            name: file.name,
            extension: extension,
            sizeBytes: file.size,
            path: file.path,
          ),
        );
      }
    }
  }

  void _removeFile(BuildContext context, String name) {
    context.read<AppFileGridBloc>().add(RemoveFile(name));
  }

  Future<void> _send(BuildContext context, List<AppFileGridItem> files) async {
    if (widget.controller!.text.trim().isEmpty && files.isEmpty) return;
    setState(() => _sending = true);
    // TODO: передать PlatformFile
    widget.onSend(widget.controller?.text.trim() ?? '', []);
    setState(() {
      widget.controller!.clear();
      _sending = false;
    });
    // Очищаем файлы
    for (final file in files) {
      _removeFile(context, file.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppFileGridBloc(),
      child: BlocBuilder<AppFileGridBloc, AppFileGridState>(
        builder: (context, state) {
          final files = state.files;
          return SafeArea(
            child: Container(
              constraints: const BoxConstraints(minHeight: 60, maxHeight: 266),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    widget.showMentions
                        ? BorderRadius.zero
                        : const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.replyTo != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.icons.chat.replyIcon.path,
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 1,
                          child: SvgPicture.asset(
                            Assets.icons.chat.replayDivider.path,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'В ответ ${widget.replyTo.senderName}',
                                style: AppTypography.text2Semibold,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.replyTo.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.text2Regular,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: widget.onCancelReply,
                          behavior: HitTestBehavior.opaque,
                          child: SvgPicture.asset(
                            Assets.icons.chat.deleteReplay.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          Assets.icons.chat.chatAttachment.path,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () => _pickFile(),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.gray500),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (files.isNotEmpty) ...[
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        for (final file in files)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: ChatFileGridCard(
                                              item: file,
                                              onRemove:
                                                  () => _removeFile(
                                                    context,
                                                    file.name,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 8,
                                    color: AppColors.gray200,
                                  ),
                                ],
                                TextField(
                                  controller: widget.controller,
                                  minLines: 1,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: 'Ваш комментарий',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  onChanged: widget.onTextChanged,
                                  onSubmitted: (_) => _send(context, files),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (widget.controller!.text.trim().isNotEmpty ||
                          files.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              Assets.icons.chat.chatSendMessage.path,
                              width: 32,
                              height: 32,
                            ),
                            onPressed:
                                _sending ? null : () => _send(context, files),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
