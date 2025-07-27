part of 'violation_request_bloc.dart';

enum ViolationRequestField { subject, description }

abstract class ViolationRequestEvent {}

class ViolationRequestFieldChanged extends ViolationRequestEvent {
  final ViolationRequestField field;
  final dynamic value;
  ViolationRequestFieldChanged(this.field, this.value);
}

class ViolationRequestCheckboxChanged extends ViolationRequestEvent {
  final bool value;
  ViolationRequestCheckboxChanged({required this.value});
}

class ViolationRequestFilesChanged extends ViolationRequestEvent {
  final List<AppFileGridItem> files;
  ViolationRequestFilesChanged(this.files);
}

class ViolationRequestSubmit extends ViolationRequestEvent {}

class ViolationRequestFieldBlurred extends ViolationRequestEvent {
  final ViolationRequestField field;
  ViolationRequestFieldBlurred(this.field);
}
