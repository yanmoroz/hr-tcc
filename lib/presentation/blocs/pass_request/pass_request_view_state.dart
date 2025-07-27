part of 'pass_request_view_bloc.dart';

abstract class PassRequestViewState {}

class PassRequestViewInitial extends PassRequestViewState {}

class PassRequestViewLoading extends PassRequestViewState {}

class PassRequestViewLoaded extends PassRequestViewState {
  final PassRequest details;
  PassRequestViewLoaded(this.details);
}

class PassRequestViewError extends PassRequestViewState {
  final String message;
  PassRequestViewError(this.message);
}
