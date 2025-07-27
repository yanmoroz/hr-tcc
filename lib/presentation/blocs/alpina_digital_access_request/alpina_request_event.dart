part of 'alpina_request_bloc.dart';

abstract class AlpinaRequestEvent {}

class AlpinaRequestFieldChanged extends AlpinaRequestEvent {
  final AlpinaDigitalAccessRequestField field;
  final dynamic value;
  AlpinaRequestFieldChanged(this.field, this.value);
}

class AlpinaRequestCheckboxChanged extends AlpinaRequestEvent {
  final bool value;
  AlpinaRequestCheckboxChanged({required this.value});
}

class AlpinaRequestSubmit extends AlpinaRequestEvent {}
