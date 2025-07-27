import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:intl/intl.dart';

import '../../cubits/snackbar/snackbar_cubit.dart';
import '../../pages/helpers/helpers.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SnackBarCubit snackBarCubit;
  final FeatchLinkContentUseCase linkContentUse;

  ChatBloc({required this.snackBarCubit, required this.linkContentUse})
    : super(
        ChatState(
          messages: _initialMessages,
          currentUserId: 'user2',
          allUsers: _initialUsers,
        ),
      ) {
    on<SendMessage>(_onSendMessage);
    on<TapOnFileChat>(_onTapFileChat);
    on<ReplyToMessage>((event, emit) {
      emit(state.copyWith(replyToMessage: event.message));
    });
    on<CancelReply>((event, emit) {
      emit(state.copyWith(replyToMessage: null));
    });
    on<ChatLikePressed>(_onLikePressed);
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final today = DateTime.now();
    final newMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: 'Климов Михаил',
      message: event.text,
      avatarUrl: null,
      isLike: false,
      likesCount: 0,
      userId: state.currentUserId,
      replyToId: event.replyTo?.id,
      date: today,
    );
    emit(
      state.copyWith(
        messages: List.from(state.messages)..add(newMsg),
        replyToMessage: null,
      ),
    );
  }

  void _onTapFileChat(TapOnFileChat event, Emitter<ChatState> emit) {
    LinkActionHelper.onLinkTap(snackBarCubit, event.fileUrl, linkContentUse);
  }

  void _onLikePressed(ChatLikePressed event, Emitter<ChatState> emit) {
    final updatedMessages = List<ChatMessageModel>.from(state.messages);
    final index = updatedMessages.indexWhere((m) => m.id == event.message.id);

    if (index != -1) {
      final oldMessage = updatedMessages[index];
      final updatedMessage = oldMessage.copyWith(
        likesCount:
            oldMessage.isLike == true
                ? oldMessage.likesCount - 1
                : oldMessage.likesCount + 1,
        isLike: !oldMessage.isLike,
      );
      updatedMessages[index] = updatedMessage;
      emit(state.copyWith(messages: updatedMessages));
    }
  }

  List<ChatUserMentionModel> searchUsersByQuery(String query) {
    return state.allUsers
        .where((u) => u.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Начальные сообщения
  static final _initialMessages = [
    ChatMessageModel(
      id: '1',
      senderName: 'Гребенников Владимир',
      message:
          'Audi A6 C5 это бесспорно дешевый входной билет в некро премиум и познание автомобилей ваг группы',
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      chatFileModels: [
        const ChatFileModel(
          fileName: 'Название файла.docx',
          fileSizeBytes: 21944,
          filesUrl:
              'https://officeprotocoldoc.z19.web.core.windows.net/files/MS-DOCX/%5bMS-DOCX%5d-250218.docx',
        ),
      ],
      userId: 'user1',
      isLike: false,
      likesCount: 0,
      replyToId: null,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ChatMessageModel(
      id: '2',
      senderName: 'Гребенников Владимир',
      message:
          'Audi A6 C5 это бесспорно дешевый входной билет в некро премиум и познание автомобилей ваг группы',
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      chatFileModels: [
        const ChatFileModel(
          fileName: 'Название файла.docx',
          fileSizeBytes: 21944,
          filesUrl:
              'https://officeprotocoldoc.z19.web.core.windows.net/files/MS-DOCX/%5bMS-DOCX%5d-250218.docx',
        ),
      ],
      userId: 'user1',
      isLike: false,
      likesCount: 0,
      replyToId: null,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ChatMessageModel(
      id: '3',
      senderName: 'Гребенников Владимир',
      message:
          'Audi A6 C5 это бесспорно дешевый входной билет в некро премиум и познание автомобилей ваг группы',
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      chatFileModels: [
        const ChatFileModel(
          fileName: 'Название файла.docx',
          fileSizeBytes: 21944,
          filesUrl:
              'https://officeprotocoldoc.z19.web.core.windows.net/files/MS-DOCX/%5bMS-DOCX%5d-250218.docx',
        ),
      ],
      userId: 'user1',
      isLike: false,
      likesCount: 0,
      replyToId: null,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ChatMessageModel(
      id: '4',
      senderName: 'Климов Михаил',
      message: 'Отличное предложение!\nЗабронировал',
      avatarUrl: null,
      userId: 'user2',
      isLike: false,
      likesCount: 0,
      replyToId: null,
      date: DateTime.now(),
    ),
  ];

  // начальные пользователи
  static final _initialUsers = [
    ChatUserMentionModel(id: '1', name: 'Климов Михаил', initials: 'МК'),
    ChatUserMentionModel(id: '2', name: 'Акимова Василиса', initials: 'ВА'),
    ChatUserMentionModel(id: '3', name: 'Семенова Дарья', initials: 'ДС'),
  ];
}
