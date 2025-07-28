part of 'polls_list_bloc.dart';

abstract class PollsListEvent {}

class LoadPollsList extends PollsListEvent {}

class FilterPollsListByStatus extends PollsListEvent {
  final PollStatus status;
  FilterPollsListByStatus(this.status);
}

class LoadMoreFinishedPollsList extends PollsListEvent {}
