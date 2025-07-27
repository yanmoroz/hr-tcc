part of 'work_certificate_request_bloc.dart';

abstract class WorkCertificateRequestEvent {}

class WorkCertificateRequestFieldChanged extends WorkCertificateRequestEvent {
  final WorkCertificateRequestField field;
  final dynamic value;
  WorkCertificateRequestFieldChanged(this.field, this.value);
}

class WorkCertificateRequestFieldBlurred extends WorkCertificateRequestEvent {
  final WorkCertificateRequestField field;
  WorkCertificateRequestFieldBlurred(this.field);
}

class WorkCertificateRequestSubmit extends WorkCertificateRequestEvent {}
