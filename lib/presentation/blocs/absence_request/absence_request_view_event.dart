part of 'absence_request_view_bloc.dart';

abstract class AbsenceRequestViewEvent {}

class LoadAbsenceRequestDetails extends AbsenceRequestViewEvent {
  final String id;
  LoadAbsenceRequestDetails(this.id);
}
