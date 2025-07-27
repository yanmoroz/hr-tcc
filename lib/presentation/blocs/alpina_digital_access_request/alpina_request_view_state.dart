part of 'alpina_request_view_bloc.dart';

abstract class AlpinaRequestViewState {}

class AlpinaDigitalAccessRequestInitial extends AlpinaRequestViewState {}

class AlpinaDigitalAccessRequestLoading extends AlpinaRequestViewState {}

class AlpinaDigitalAccessRequestLoaded extends AlpinaRequestViewState {
  final AlpinaDigitalAccessRequest details;
  AlpinaDigitalAccessRequestLoaded(this.details);
}

class AlpinaDigitalAccessRequestError extends AlpinaRequestViewState {
  final String message;
  AlpinaDigitalAccessRequestError(this.message);
}
