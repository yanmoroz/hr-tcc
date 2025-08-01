import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/poll_status.dart';
import '../../../domain/usecases/get_polls_usecase.dart';
import '../../viewmodels/polls_list_view_model.dart';

part 'polls_list_event.dart';
part 'polls_list_state.dart';

class PollsListBloc extends Bloc<PollsListEvent, PollsListState> {
  final GetPollsUseCase getPollsUseCase;

  PollsListBloc({required this.getPollsUseCase}) : super(PollsListInitial()) {
    on<LoadPolls>(_onInitialLoad);
    // on<LoadMoreFinishedPolls>(_onLoadMoreFinishedPolls);
    // on<FilterPollsByStatus>(_onFilter);
  }

  Future<void> _onInitialLoad(
    LoadPolls event,
    Emitter<PollsListState> emit,
  ) async {
    const page = 1;
    const pageSize = 5;

    emit(PollsListLoading());

    final pagedResult = await getPollsUseCase(page: page, pageSize: pageSize);
    final viewModel = PollsListViewModel.fromEntities(pagedResult.items);

    emit(PollsListLoaded(viewModel: viewModel));

    //   final notPassed = _mapPollsList(res.notPassedRaw, PollStatus.notPassed);
    //   final passed = _mapPollsList(res.passedRaw, PollStatus.passed);

    //   final grouped = {
    //     PollStatus.notPassed: notPassed,
    //     PollStatus.passed: passed,
    //   };

    //   final filterTabs = _buildFilters(res.notPassedTotal, res.passedTotal);

    //   emit(
    //     state.copyWith(
    //       groupedPolls: grouped,
    //       sectionTitles: _buildSectionTitles(),
    //       currentPage: page,
    //       finishedPollsTotalCount: res.passedTotal,
    //       filterTabs: filterTabs,
    //     ),
    //   );
  }

  // Future<void> _onLoadMoreFinishedPolls(
  //   LoadMoreFinishedPolls event,
  //   Emitter<PollsListState> emit,
  // ) async {
  //   if (!state.hasMorePassedPolls || state.isLoadingMore) return;

  //   emit(state.copyWith(isLoadingMore: true));

  //   final nextPage = state.currentPage + 1;
  //   const pageSize = 5;

  //   final res = await fetchPollsUseCase(page: nextPage, pageSize: pageSize);
  //   final newPassed = _mapPollsList(res.passedRaw, PollStatus.passed);

  //   final updatedPassed = [
  //     ...?state.groupedPolls[PollStatus.passed],
  //     ...newPassed,
  //   ];

  //   final updatedGrouped = Map<PollStatus, List<PollCardModel>>.from(
  //     state.groupedPolls,
  //   )..[PollStatus.passed] = updatedPassed;

  //   emit(
  //     state.copyWith(
  //       groupedPolls: updatedGrouped,
  //       currentPage: nextPage,
  //       isLoadingMore: false,
  //     ),
  //   );
  // }

  // void _onFilter(FilterPollsByStatus event, Emitter<PollsListState> emit) {
  //   emit(state.copyWith(selectedFilter: event.status));
  // }

  // List<PollCardModel> _mapPollsList(List data, PollStatus status) =>
  //     data.map((e) => PollCardModel.fromJson(e, status)).toList();

  // Map<PollStatus, String> _buildSectionTitles() => {
  //   PollStatus.notPassed: 'Непройденные',
  //   PollStatus.passed: 'Пройденные',
  // };

  // List<FilterTabModel<PollStatus>> _buildFilters(int notPassed, int passed) {
  //   return [
  //     FilterTabModel(
  //       label: 'Все',
  //       value: PollStatus.all,
  //       count: notPassed + passed,
  //     ),
  //     FilterTabModel(
  //       label: 'Непройденные',
  //       value: PollStatus.notPassed,
  //       count: notPassed,
  //     ),
  //     FilterTabModel(
  //       label: 'Пройденные',
  //       value: PollStatus.passed,
  //       count: passed,
  //     ),
  //   ];
  // }
}
