part of 'absence_request_view_bloc.dart';

abstract class AbsenceRequestViewState {}

class AbsenceRequestViewInitial extends AbsenceRequestViewState {}

class AbsenceRequestViewLoading extends AbsenceRequestViewState {}

class AbsenceRequestViewLoaded extends AbsenceRequestViewState {
  final AbsenceRequest details;
  AbsenceRequestViewLoaded(this.details);
}

class AbsenceRequestViewError extends AbsenceRequestViewState {
  final String message;
  AbsenceRequestViewError(this.message);
}
