import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';

part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final FetchRequestsUseCase fetchRequestsUseCase;
  static const int _pageSize = 10;
  RequestStatus? _status;
  String? _query;
  final Map<String, _RequestsTabState> _tabStates = {};
  Map<RequestStatus, int> tabCounts = {};

  String _tabKey(RequestStatus? status, String? query) =>
      '${status?.name ?? 'all'}|${query ?? ''}';

  RequestsBloc(this.fetchRequestsUseCase) : super(RequestsInitial()) {
    on<RequestsLoad>(_onLoad);
    on<RequestsReload>(_onReload);
    on<RequestsLoadMore>(_onLoadMore);
    on<RequestsFilterChanged>(_onFilterChanged);
    on<RequestsSearchChanged>(_onSearchChanged);
    on<UpdateRequestStatusTabCounts>(_onUpdateRequestStatusTabCounts);
    on<UpdateRequestStatusTabCountsTrigger>(
      _onUpdateRequestStatusTabCountsTrigger,
    );
  }

  Future<void> _updateRequestStatusTabCounts() async {
    final repo = fetchRequestsUseCase.repository;
    final counts = await repo.fetchRequestsCountByStatus(query: _query);
    tabCounts = counts;
    add(UpdateRequestStatusTabCounts(counts));
  }

  void _onUpdateRequestStatusTabCounts(
    UpdateRequestStatusTabCounts event,
    Emitter<RequestsState> emit,
  ) {
    tabCounts = event.counts;
    // Не эмитим отдельное состояние, counts будут использоваться в UI через bloc.tabCounts
  }

  Future<void> _onUpdateRequestStatusTabCountsTrigger(
    UpdateRequestStatusTabCountsTrigger event,
    Emitter<RequestsState> emit,
  ) async {
    final repo = fetchRequestsUseCase.repository;
    final counts = await repo.fetchRequestsCountByStatus(query: event.query);
    tabCounts = counts;
    add(UpdateRequestStatusTabCounts(counts));
  }

  Future<void> _onLoad(RequestsLoad event, Emitter<RequestsState> emit) async {
    emit(RequestsLoading());
    if (event.status != null) _status = event.status;
    if (event.query != null) _query = event.query;
    final key = _tabKey(_status, _query);
    var tabState = _tabStates[key] ?? _RequestsTabState(page: 1, hasMore: true);
    tabState.page = 1;
    tabState.hasMore = true;
    final requests = await fetchRequestsUseCase(
      page: tabState.page,
      pageSize: _pageSize,
      status: _status,
      query: _query,
    );
    tabState.requests = requests;
    tabState.hasMore = requests.length == _pageSize;
    _tabStates[key] = tabState;
    await _updateRequestStatusTabCounts();
    emit(
      RequestsLoaded(requests: tabState.requests, hasMore: tabState.hasMore),
    );
  }

  Future<void> _onReload(
    RequestsReload event,
    Emitter<RequestsState> emit,
  ) async {
    final status = event.status ?? _status;
    final query = event.query ?? _query;
    final key = _tabKey(status, query);
    _tabStates.remove(key);
    add(RequestsLoad(status: status, query: query));
  }

  Future<void> _onLoadMore(
    RequestsLoadMore event,
    Emitter<RequestsState> emit,
  ) async {
    final key = _tabKey(_status, _query);
    var tabState = _tabStates[key] ?? _RequestsTabState(page: 1, hasMore: true);
    if (!tabState.hasMore || state is RequestsLoading) return;
    tabState.page++;
    final more = await fetchRequestsUseCase(
      page: tabState.page,
      pageSize: _pageSize,
      status: _status,
      query: _query,
    );
    if (more.isEmpty || more.length < _pageSize) {
      tabState.hasMore = false;
    }
    tabState.requests.addAll(more);
    _tabStates[key] = tabState;
    emit(
      RequestsLoaded(requests: tabState.requests, hasMore: tabState.hasMore),
    );
  }

  void _onFilterChanged(
    RequestsFilterChanged event,
    Emitter<RequestsState> emit,
  ) {
    _status = event.status;
    final key = _tabKey(_status, _query);
    _updateRequestStatusTabCounts();
    if (_tabStates.containsKey(key)) {
      final tabState = _tabStates[key]!;
      emit(
        RequestsLoaded(requests: tabState.requests, hasMore: tabState.hasMore),
      );
    } else {
      add(RequestsLoad(status: _status, query: _query));
    }
  }

  void _onSearchChanged(
    RequestsSearchChanged event,
    Emitter<RequestsState> emit,
  ) {
    _query = event.query;
    if (event.status != null) _status = event.status;
    final key = _tabKey(_status, _query);
    _updateRequestStatusTabCounts();
    if (_tabStates.containsKey(key)) {
      final tabState = _tabStates[key]!;
      emit(
        RequestsLoaded(requests: tabState.requests, hasMore: tabState.hasMore),
      );
    } else {
      add(RequestsLoad(status: _status, query: _query));
    }
  }
}

class _RequestsTabState {
  int page;
  bool hasMore;
  List<Request> requests;

  _RequestsTabState({
    required this.page,
    required this.hasMore,
    List<Request>? requests,
  }) : requests = requests ?? [];
}
