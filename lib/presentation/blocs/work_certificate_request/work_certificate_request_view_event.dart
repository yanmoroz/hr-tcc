part of 'work_certificate_request_view_bloc.dart';

abstract class WorkCertificateRequestViewEvent {}

class LoadWorkCertificateRequestDetails
    extends WorkCertificateRequestViewEvent {
  final String id;
  LoadWorkCertificateRequestDetails(this.id);
}
