part of 'poll_detail_page_bloc.dart';

abstract class PollDetailPageEvent extends Equatable {
  const PollDetailPageEvent();
  @override
  List<Object?> get props => [];
}

class PollDetailPageStarted extends PollDetailPageEvent {
  final String pollId;
  const PollDetailPageStarted(this.pollId);
  @override
  List<Object?> get props => [pollId];
}

class PollDetailPageAnswerChanged extends PollDetailPageEvent {
  final String questionId;
  final PollAnswerAbstractModel updatedAnswer;
  const PollDetailPageAnswerChanged({
    required this.questionId,
    required this.updatedAnswer,
  });

  @override
  List<Object?> get props => [questionId, updatedAnswer];
}

class PollDetailPageSubmitted extends PollDetailPageEvent {}