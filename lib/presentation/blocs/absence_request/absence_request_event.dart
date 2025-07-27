part of 'absence_request_bloc.dart';

abstract class AbsenceRequestEvent {}

class AbsenceRequestFieldChanged extends AbsenceRequestEvent {
  final AbsenceRequestField field;
  final dynamic value;
  AbsenceRequestFieldChanged(this.field, this.value);
}

class AbsenceRequestSubmit extends AbsenceRequestEvent {}

class AbsenceRequestFieldBlurred extends AbsenceRequestEvent {
  final AbsenceRequestField field;
  AbsenceRequestFieldBlurred(this.field);
}
