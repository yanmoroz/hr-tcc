part of 'work_book_request_bloc.dart';

abstract class WorkBookRequestEvent {}

class WorkBookRequestFieldChanged extends WorkBookRequestEvent {
  final WorkBookRequestField field;
  final dynamic value;
  WorkBookRequestFieldChanged(this.field, this.value);
}

class WorkBookRequestFieldBlurred extends WorkBookRequestEvent {
  final WorkBookRequestField field;
  WorkBookRequestFieldBlurred(this.field);
}

class WorkBookRequestSubmit extends WorkBookRequestEvent {}
