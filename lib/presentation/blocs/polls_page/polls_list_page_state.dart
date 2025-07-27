part of 'polls_list_page_bloc.dart';

class PollsListPageState {
  final Map<PollStatus, List<PollCardModel>> groupedPolls;
  final Map<PollStatus, String> sectionTitles;
  final PollStatus? selectedFilter;
  final int currentPage;
  final int? finishedPollsTotalCount;
  final bool isLoadingMore;
  final List<FilterTabModel<PollStatus>>? filterTabs;

  bool get hasMorePassedPolls =>
      (groupedPolls[PollStatus.passed]?.length ?? 0) <
      (finishedPollsTotalCount ?? 0);

  PollsListPageState({
    required this.groupedPolls,
    required this.sectionTitles,
    this.selectedFilter,
    required this.currentPage,
    required this.finishedPollsTotalCount,
    required this.isLoadingMore,
    this.filterTabs,
  });

  factory PollsListPageState.initial() => PollsListPageState(
    groupedPolls: {},
    sectionTitles: {},
    selectedFilter: PollStatus.all,
    currentPage: 1,
    finishedPollsTotalCount: 0,
    isLoadingMore: false,
    filterTabs: null,
  );

  PollsListPageState copyWith({
    Map<PollStatus, List<PollCardModel>>? groupedPolls,
    Map<PollStatus, String>? sectionTitles,
    PollStatus? selectedFilter,
    int? currentPage,
    int? finishedPollsTotalCount,
    bool? isLoadingMore,
    List<FilterTabModel<PollStatus>>? filterTabs,
  }) {
    return PollsListPageState(
      groupedPolls: groupedPolls ?? this.groupedPolls,
      sectionTitles: sectionTitles ?? this.sectionTitles,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      finishedPollsTotalCount:
          finishedPollsTotalCount ?? this.finishedPollsTotalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      filterTabs: filterTabs ?? this.filterTabs,
    );
  }
}
