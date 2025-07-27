import 'package:hr_tcc/models/models.dart';

class ChatMessageModel {
  final String id;
  final String senderName;
  final String message;
  final String? avatarUrl;
  final List<ChatFileModel>? chatFileModels;
  final String userId;
  final bool isLike;
  final int likesCount;
  final String? replyToId;
  final DateTime date;

  ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.message,
    this.avatarUrl,
    this.chatFileModels,
    required this.userId,
    required this.isLike,
    required this.likesCount,
    this.replyToId,
    required this.date,
  });

  ChatMessageModel copyWith({
    String? id,
    String? senderName,
    String? message,
    String? avatarUrl,
    List<ChatFileModel>? chatFileModel,
    String? userId,
    bool? isLike,
    int? likesCount,
    String? replyToId,
    DateTime? date,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      chatFileModels: chatFileModel ?? chatFileModels,
      userId: userId ?? this.userId,
      isLike: isLike ?? this.isLike,
      likesCount: likesCount ?? this.likesCount,
      replyToId: replyToId ?? this.replyToId,
      date: date ?? this.date,
    );
  }
}
