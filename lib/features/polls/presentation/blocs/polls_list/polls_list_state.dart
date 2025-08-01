part of 'polls_list_bloc.dart';

abstract class PollsListState {}

class PollsListInitial extends PollsListState {}

class PollsListLoading extends PollsListState {}

class PollsListLoaded extends PollsListState {
  final PollsListViewModel viewModel;

  PollsListLoaded({required this.viewModel});
}

// abstract class PollsListState {
  // final Map<PollStatus, List<PollCardModel>> groupedPolls;
  // final Map<PollStatus, String> sectionTitles;
  // final PollStatus? selectedFilter;
  // final int currentPage;
  // final int? finishedPollsTotalCount;
  // final bool isLoadingMore;
  // final List<FilterTabModel<PollStatus>>? filterTabs;

  // bool get hasMorePassedPolls =>
  //     (groupedPolls[PollStatus.passed]?.length ?? 0) <
  //     (finishedPollsTotalCount ?? 0);

  // PollsListState({
  // required this.groupedPolls,
  // required this.sectionTitles,
  // this.selectedFilter,
  // required this.currentPage,
  // required this.finishedPollsTotalCount,
  // required this.isLoadingMore,
  // this.filterTabs,
  // });

  // factory PollsListState.initial() => PollsListState(
  //   groupedPolls: {},
  //   sectionTitles: {},
  //   selectedFilter: PollStatus.all,
  //   currentPage: 1,
  //   finishedPollsTotalCount: 0,
  //   isLoadingMore: false,
  //   filterTabs: null,
  // );

  // PollsListState copyWith({
  //   Map<PollStatus, List<PollCardModel>>? groupedPolls,
  //   Map<PollStatus, String>? sectionTitles,
  //   PollStatus? selectedFilter,
  //   int? currentPage,
  //   int? finishedPollsTotalCount,
  //   bool? isLoadingMore,
  //   List<FilterTabModel<PollStatus>>? filterTabs,
  // }) {
  //   return PollsListState(
  //     groupedPolls: groupedPolls ?? this.groupedPolls,
  //     sectionTitles: sectionTitles ?? this.sectionTitles,
  //     selectedFilter: selectedFilter ?? this.selectedFilter,
  //     currentPage: currentPage ?? this.currentPage,
  //     finishedPollsTotalCount:
  //         finishedPollsTotalCount ?? this.finishedPollsTotalCount,
  //     isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  //     filterTabs: filterTabs ?? this.filterTabs,
  //   );
  // }
// }
