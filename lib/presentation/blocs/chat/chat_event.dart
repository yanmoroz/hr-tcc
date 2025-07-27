part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchUsersByQuery extends ChatEvent {
  final String query;
  SearchUsersByQuery(this.query);
}

class SendMessage extends ChatEvent {
  final String text;
  final List<PlatformFile> files;
  final ChatMessageModel? replyTo;
  SendMessage({required this.text, required this.files, this.replyTo});
}

class ReplyToMessage extends ChatEvent {
  final ChatMessageModel message;
  ReplyToMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class ChatLikePressed extends ChatEvent {
  final ChatMessageModel message;
  ChatLikePressed(this.message);
  @override
  List<Object?> get props => [message];
}

class CancelReply extends ChatEvent {}

class TapOnFileChat extends ChatEvent {
  final String fileUrl;
  TapOnFileChat({required this.fileUrl});
}
