part of 'alpina_request_view_bloc.dart';

abstract class AlpinaRequestViewEvent {}

class LoadAlpinaDigitalAccessRequestDetails extends AlpinaRequestViewEvent {
  final String id;
  LoadAlpinaDigitalAccessRequestDetails(this.id);
}
