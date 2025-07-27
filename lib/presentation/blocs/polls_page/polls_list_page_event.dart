part of 'polls_list_page_bloc.dart';

abstract class PollsListPageEvent {}

class LoadPollsListPage extends PollsListPageEvent {}

class FilterPollsListByStatus extends PollsListPageEvent {
  final PollStatus status;
  FilterPollsListByStatus(this.status);
}

class LoadMoreFinishedPollsList extends PollsListPageEvent {}
