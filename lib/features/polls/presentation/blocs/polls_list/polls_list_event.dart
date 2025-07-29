part of 'polls_list_bloc.dart';

abstract class PollsListEvent {}

class LoadPolls extends PollsListEvent {}

class FilterPollsByStatus extends PollsListEvent {
  final PollStatus status;

  FilterPollsByStatus(this.status);
}

class LoadMoreFinishedPolls extends PollsListEvent {}
