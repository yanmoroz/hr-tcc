part of 'violation_request_view_bloc.dart';

abstract class ViolationRequestViewState {}

class ViolationRequestViewInitial extends ViolationRequestViewState {}

class ViolationRequestViewLoading extends ViolationRequestViewState {}

class ViolationRequestViewLoaded extends ViolationRequestViewState {
  final ViolationRequest details;
  ViolationRequestViewLoaded(this.details);
}

class ViolationRequestViewError extends ViolationRequestViewState {
  final String message;
  ViolationRequestViewError(this.message);
}
