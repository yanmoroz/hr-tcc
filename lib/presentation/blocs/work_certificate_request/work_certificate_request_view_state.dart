part of 'work_certificate_request_view_bloc.dart';

abstract class WorkCertificateRequestViewState {}

class WorkCertificateRequestViewInitial
    extends WorkCertificateRequestViewState {}

class WorkCertificateRequestViewLoading
    extends WorkCertificateRequestViewState {}

class WorkCertificateRequestViewLoaded extends WorkCertificateRequestViewState {
  final WorkCertificateRequest details;
  WorkCertificateRequestViewLoaded(this.details);
}

class WorkCertificateRequestViewError extends WorkCertificateRequestViewState {
  final String message;
  WorkCertificateRequestViewError(this.message);
}
