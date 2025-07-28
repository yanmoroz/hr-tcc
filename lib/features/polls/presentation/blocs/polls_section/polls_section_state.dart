part of 'polls_section_bloc.dart';

abstract class PollsSectionState {}

class PollsSectionInitial extends PollsSectionState {}

class PollsSectionLoaded extends PollsSectionState {
  final List<PollCardModel> polls;

  PollsSectionLoaded({required this.polls});
}
