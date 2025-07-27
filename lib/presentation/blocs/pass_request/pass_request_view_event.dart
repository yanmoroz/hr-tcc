part of 'pass_request_view_bloc.dart';

abstract class PassRequestViewEvent {}

class LoadPassRequestDetails extends PassRequestViewEvent {
  final String id;
  LoadPassRequestDetails(this.id);
}
