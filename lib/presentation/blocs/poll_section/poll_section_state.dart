part of 'poll_section_bloc.dart';

abstract class PollSectionState {}

class PollSectionInitial extends PollSectionState {}

class PollSectionLoaded extends PollSectionState {
  final List<PollCardModel> polls;

  PollSectionLoaded({required this.polls});
}