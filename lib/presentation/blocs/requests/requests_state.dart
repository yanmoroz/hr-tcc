part of 'requests_bloc.dart';

abstract class RequestsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final List<Request> requests;
  final bool hasMore;
  RequestsLoaded({required this.requests, required this.hasMore});
  @override
  List<Object?> get props => [requests, hasMore];
}

class RequestsError extends RequestsState {
  final String message;
  RequestsError(this.message);
  @override
  List<Object?> get props => [message];
}
