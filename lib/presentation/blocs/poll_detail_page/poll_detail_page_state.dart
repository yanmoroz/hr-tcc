part of 'poll_detail_page_bloc.dart';

abstract class PollDetailPageState extends Equatable {
  const PollDetailPageState();
  @override
  List<Object?> get props => [];
}

class PollDetailPageLoading extends PollDetailPageState {}

class PollDetailPageFailure extends PollDetailPageState {
  final String message;
  const PollDetailPageFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class PollDetailPageLoaded extends PollDetailPageState {
  final PollDetailModel poll;
  final Map<String, List<PollAnswerAbstractModel>> answers;
  final bool allRequiredFilled;
  const PollDetailPageLoaded({
    required this.poll,
    required this.answers,
    required this.allRequiredFilled,
  });

  PollDetailPageLoaded copyWith({
    PollDetailModel? poll,
    Map<String, List<PollAnswerAbstractModel>>? answers,
    bool? allRequiredFilled,
  }) {
    return PollDetailPageLoaded(
      poll: poll ?? this.poll,
      answers: answers ?? this.answers,
      allRequiredFilled: allRequiredFilled ?? this.allRequiredFilled,
    );
  }

  @override
  List<Object?> get props => [poll, answers, allRequiredFilled];
}

class PollDetailPageSubmitting extends PollDetailPageState {}

class PollDetailPageSuccess extends PollDetailPageState {}
