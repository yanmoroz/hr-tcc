part of 'poll_detail_bloc.dart';

sealed class PollDetailState extends Equatable {
  const PollDetailState();
  @override
  List<Object?> get props => [];
}

class PollDetailLoading extends PollDetailState {}

class PollDetailFailure extends PollDetailState {
  final String message;
  const PollDetailFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class PollDetailLoaded extends PollDetailState {
  final PollDetailModel poll;
  final Map<String, List<PollAnswerAbstractModel>> answers;
  final bool allRequiredFilled;
  const PollDetailLoaded({
    required this.poll,
    required this.answers,
    required this.allRequiredFilled,
  });

  PollDetailLoaded copyWith({
    PollDetailModel? poll,
    Map<String, List<PollAnswerAbstractModel>>? answers,
    bool? allRequiredFilled,
  }) {
    return PollDetailLoaded(
      poll: poll ?? this.poll,
      answers: answers ?? this.answers,
      allRequiredFilled: allRequiredFilled ?? this.allRequiredFilled,
    );
  }

  @override
  List<Object?> get props => [poll, answers, allRequiredFilled];
}

class PollDetailSubmitting extends PollDetailState {}

class PollDetailSuccess extends PollDetailState {}
