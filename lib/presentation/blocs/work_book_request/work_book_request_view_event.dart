part of 'work_book_request_view_bloc.dart';

abstract class WorkBookRequestViewEvent {}

class LoadWorkBookRequestDetails extends WorkBookRequestViewEvent {
  final String id;
  LoadWorkBookRequestDetails(this.id);
}
