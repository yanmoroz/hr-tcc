part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatMessageModel> messages;
  final ChatMessageModel? replyToMessage;
  final String currentUserId;

  final List<ChatUserMentionModel> allUsers;
  final int? mentionStartIdx;
  final String? floatingDateLabel;
  final bool showFloatingDate;

  const ChatState({
    required this.messages,
    this.replyToMessage,
    required this.currentUserId,
    required this.allUsers,
    this.mentionStartIdx,
    this.floatingDateLabel,
    this.showFloatingDate = false,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    ChatMessageModel? replyToMessage,
    String? currentUserId,
    List<ChatUserMentionModel>? allUsers,

    String? floatingDateLabel,
    bool? showFloatingDate,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      replyToMessage: replyToMessage,
      currentUserId: currentUserId ?? this.currentUserId,
      allUsers: allUsers ?? this.allUsers,
      floatingDateLabel: floatingDateLabel ?? this.floatingDateLabel,
      showFloatingDate: showFloatingDate ?? this.showFloatingDate,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    replyToMessage,
    currentUserId,
    allUsers,
    mentionStartIdx,
    floatingDateLabel,
    showFloatingDate,
  ];

  // Группировка сообщений по дню с ключами уже отформатированными строками
  Map<String, List<ChatMessageModel>> get groupedMessagesByDay {
    final Map<String, List<ChatMessageModel>> grouped = {};

    for (final msg in messages) {
      final key = '${msg.date.year}-${msg.date.month}-${msg.date.day}';
      grouped.putIfAbsent(key, () => []).add(msg);
    }

    final sortedKeys =
        grouped.keys.toList()..sort((a, b) {
          final aParts = a.split('-').map(int.parse).toList();
          final bParts = b.split('-').map(int.parse).toList();
          final aDate = DateTime(aParts[0], aParts[1], aParts[2]);
          final bDate = DateTime(bParts[0], bParts[1], bParts[2]);
          return aDate.compareTo(bDate);
        });

    final Map<String, List<ChatMessageModel>> result = {};
    for (final key in sortedKeys) {
      final parts = key.split('-').map(int.parse).toList();
      final date = DateTime(parts[0], parts[1], parts[2]);

      final formattedDate = _formatDate(date);

      result[formattedDate] = grouped[key]!;
    }

    return result;
  }

  // Группировка сообщений по дням
  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Сегодня';
    }

    final formatter = DateFormat('d MMMM', 'ru');
    return formatter.format(date);
  }
}
