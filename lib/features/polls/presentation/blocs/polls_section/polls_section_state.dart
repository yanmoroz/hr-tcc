part of 'polls_section_bloc.dart';

abstract class PollsSectionState {}

class Initial extends PollsSectionState {}

class PollsLoaded extends PollsSectionState {
  final List<PollCardViewModel> polls;

  PollsLoaded({required this.polls});
}
