import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';

part 'request_types_event.dart';
part 'request_types_state.dart';

class RequestTypesBloc extends Bloc<RequestTypesEvent, RequestTypesState> {
  final FetchRequestTypesUseCase fetchRequestTypesUseCase;
  final FetchRequestTypesCountUseCase fetchRequestTypesCountUseCase;
  Map<RequestGroup, int> tabCounts = {};

  RequestTypesBloc(
    this.fetchRequestTypesUseCase,
    this.fetchRequestTypesCountUseCase,
  ) : super(RequestTypesInitial()) {
    on<RequestTypesLoad>(_onLoad);
    on<RequestTypesGroupChanged>(_onGroupChanged);
    on<RequestTypesSearchChanged>(_onSearchChanged);
    on<UpdateRequestTypeTabCounts>(_onUpdateRequestTypeTabCounts);
    on<UpdateRequestTypeTabCountsTrigger>(_onUpdateRequestTypeTabCountsTrigger);
  }

  RequestGroup? _group;
  String? _query;

  Future<void> _updateRequestTypeTabCounts() async {
    final counts = await fetchRequestTypesCountUseCase(query: _query);
    tabCounts = counts;
    add(UpdateRequestTypeTabCounts(counts));
  }

  void _onUpdateRequestTypeTabCounts(
    UpdateRequestTypeTabCounts event,
    Emitter<RequestTypesState> emit,
  ) {
    tabCounts = event.counts;
  }

  Future<void> _onUpdateRequestTypeTabCountsTrigger(
    UpdateRequestTypeTabCountsTrigger event,
    Emitter<RequestTypesState> emit,
  ) async {
    final counts = await fetchRequestTypesCountUseCase(query: event.query);
    tabCounts = counts;
    add(UpdateRequestTypeTabCounts(counts));
  }

  Future<void> _onLoad(
    RequestTypesLoad event,
    Emitter<RequestTypesState> emit,
  ) async {
    emit(RequestTypesLoading());
    _group = event.group;
    _query = event.query;
    final types = await fetchRequestTypesUseCase(group: _group, query: _query);
    await _updateRequestTypeTabCounts();
    emit(RequestTypesLoaded(types: types));
  }

  void _onGroupChanged(
    RequestTypesGroupChanged event,
    Emitter<RequestTypesState> emit,
  ) {
    _updateRequestTypeTabCounts();
    add(RequestTypesLoad(group: event.group));
  }

  void _onSearchChanged(
    RequestTypesSearchChanged event,
    Emitter<RequestTypesState> emit,
  ) {
    _updateRequestTypeTabCounts();
    add(RequestTypesLoad(query: event.query));
  }
}
