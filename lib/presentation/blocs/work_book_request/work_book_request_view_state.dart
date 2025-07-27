part of 'work_book_request_view_bloc.dart';

abstract class WorkBookRequestViewState {}

class WorkBookRequestViewInitial extends WorkBookRequestViewState {}

class WorkBookRequestViewLoading extends WorkBookRequestViewState {}

class WorkBookRequestViewLoaded extends WorkBookRequestViewState {
  final WorkBookRequestDetails details;
  WorkBookRequestViewLoaded(this.details);
}

class WorkBookRequestViewError extends WorkBookRequestViewState {
  final String message;
  WorkBookRequestViewError(this.message);
}
