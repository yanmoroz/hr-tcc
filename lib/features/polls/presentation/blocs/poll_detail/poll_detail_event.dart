part of 'poll_detail_bloc.dart';

sealed class PollDetailEvent extends Equatable {
  const PollDetailEvent();
  @override
  List<Object?> get props => [];
}

class PollDetailStarted extends PollDetailEvent {
  final String pollId;
  const PollDetailStarted(this.pollId);
  @override
  List<Object?> get props => [pollId];
}

class PollDetailAnswerChanged extends PollDetailEvent {
  final String questionId;
  final PollAnswerAbstractModel updatedAnswer;
  const PollDetailAnswerChanged({
    required this.questionId,
    required this.updatedAnswer,
  });

  @override
  List<Object?> get props => [questionId, updatedAnswer];
}

class PollDetailSubmitted extends PollDetailEvent {}
