part of 'poll_section_bloc.dart';

sealed class PollSectionState {}

class PollSectionInitial extends PollSectionState {}

class PollSectionLoading extends PollSectionState {}

class PollSectionLoaded extends PollSectionState {
  final List<Poll> polls;
  PollSectionLoaded(this.polls);
}

class PollSectionError extends PollSectionState {}
