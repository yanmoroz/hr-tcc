part of 'requests_bloc.dart';

abstract class RequestsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestsLoad extends RequestsEvent {
  final RequestStatus? status;
  final String? query;
  RequestsLoad({this.status, this.query});
  @override
  List<Object?> get props => [status, query];
}

class RequestsLoadMore extends RequestsEvent {}

class RequestsFilterChanged extends RequestsEvent {
  final RequestStatus? status;
  RequestsFilterChanged(this.status);
  @override
  List<Object?> get props => [status];
}

class RequestsSearchChanged extends RequestsEvent {
  final String query;
  final RequestStatus? status;
  RequestsSearchChanged(this.query, {this.status});
  @override
  List<Object?> get props => [query, status];
}

class RequestsReload extends RequestsEvent {
  final RequestStatus? status;
  final String? query;
  RequestsReload({this.status, this.query});
  @override
  List<Object?> get props => [status, query];
}

class UpdateRequestStatusTabCounts extends RequestsEvent {
  final Map<RequestStatus, int> counts;
  UpdateRequestStatusTabCounts(this.counts);
  @override
  List<Object?> get props => [counts];
}

class UpdateRequestStatusTabCountsTrigger extends RequestsEvent {
  final String? query;
  UpdateRequestStatusTabCountsTrigger({this.query});
  @override
  List<Object?> get props => [query];
}
