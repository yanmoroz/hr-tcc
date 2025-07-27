part of 'request_types_bloc.dart';

abstract class RequestTypesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestTypesLoad extends RequestTypesEvent {
  final RequestGroup? group;
  final String? query;
  RequestTypesLoad({this.group, this.query});
  @override
  List<Object?> get props => [group, query];
}

class RequestTypesGroupChanged extends RequestTypesEvent {
  final RequestGroup? group;
  RequestTypesGroupChanged(this.group);
  @override
  List<Object?> get props => [group];
}

class RequestTypesSearchChanged extends RequestTypesEvent {
  final String query;
  RequestTypesSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class UpdateRequestTypeTabCounts extends RequestTypesEvent {
  final Map<RequestGroup, int> counts;
  UpdateRequestTypeTabCounts(this.counts);
  @override
  List<Object?> get props => [counts];
}

class UpdateRequestTypeTabCountsTrigger extends RequestTypesEvent {
  final String? query;
  UpdateRequestTypeTabCountsTrigger({this.query});
  @override
  List<Object?> get props => [query];
}
