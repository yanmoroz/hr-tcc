part of 'pass_request_bloc.dart';

abstract class PassRequestEvent {}

class PassRequestFieldChanged extends PassRequestEvent {
  final PassRequestField field;
  final dynamic value;
  PassRequestFieldChanged(this.field, this.value);
}

class PassRequestSubmitted extends PassRequestEvent {}

class PassRequestReset extends PassRequestEvent {}

class PassRequestFieldBlurred extends PassRequestEvent {
  final PassRequestField field;
  PassRequestFieldBlurred(this.field);
}
