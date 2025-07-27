import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/domain/entities/requests/request_type.dart';
import 'package:hr_tcc/presentation/pages/requests/components/request_created_alert.dart';
import 'package:hr_tcc/presentation/navigation/navigation.dart';

Future<void> navigateToRequestCreatePage(
  BuildContext context,
  RequestType? type,
) async {
  if (type == null) return;

  String route;
  switch (type) {
    case RequestType.courierDelivery:
      route = AppRoute.courierRequestCreate.path;
    case RequestType.absence:
      route = AppRoute.absenceRequestCreate.path;
    case RequestType.alpinaAccess:
      route = AppRoute.alpinaRequestCreate.path;
    case RequestType.workCertificate:
      route = AppRoute.workCertificateRequestCreate.path;
    case RequestType.violation:
      route = AppRoute.violationRequestCreate.path;
    case RequestType.referralProgram:
      route = AppRoute.referralProgramRequestCreate.path;
    case RequestType.pass:
      route = AppRoute.passRequestCreate.path;
    case RequestType.parking:
      route = AppRoute.parkingRequestCreate.path;
    case RequestType.businessTrip:
      route = AppRoute.businessTripRequestCreate.path;
    case RequestType.unplannedTraining:
      route = AppRoute.unplannedTrainingRequestCreate.path;
    case RequestType.workBookCopy:
      route = AppRoute.workBookRequestCreate.path;
    case RequestType.taxCertificate:
      route = AppRoute.twoNdflRequestCreate.path;
    case RequestType.internalTraining:
      route = AppRoute.internalTrainingRequestCreate.path;
    case RequestType.dpo:
      route = AppRoute.dpoRequestCreate.path;
  }

  // TODO: add slide from bottom transition (SlideFromBottomPageRoute)
  final result = await context.push(route);
  if (!context.mounted) return;
  if (result == true) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RequestCreatedAlert(),
    );
  }
}

void navigateToRequestViewPage(
  BuildContext context,
  RequestType type,
  String requestId,
) {
  String location;
  switch (type) {
    case RequestType.courierDelivery:
      location = AppRoute.courierRequestViewWithId(requestId);
    case RequestType.alpinaAccess:
      location = AppRoute.alpinaRequestViewWithId(requestId);
    case RequestType.workCertificate:
      location = AppRoute.workCertificateRequestViewWithId(requestId);
    case RequestType.violation:
      location = AppRoute.violationRequestViewWithId(requestId);
    case RequestType.absence:
      location = AppRoute.absenceRequestViewWithId(requestId);
    case RequestType.referralProgram:
      location = AppRoute.referralProgramRequestViewWithId(requestId);
    case RequestType.pass:
      location = AppRoute.passRequestViewWithId(requestId);
    case RequestType.parking:
      location = AppRoute.parkingRequestViewWithId(requestId);
    case RequestType.businessTrip:
      location = AppRoute.businessTripRequestViewWithId(requestId);
    case RequestType.unplannedTraining:
      location = AppRoute.unplannedTrainingRequestViewWithId(requestId);
    case RequestType.workBookCopy:
      location = AppRoute.workBookRequestViewWithId(requestId);
    case RequestType.taxCertificate:
      location = AppRoute.twoNdflRequestViewWithId(requestId);
    case RequestType.internalTraining:
      location = AppRoute.internalTrainingRequestViewWithId(requestId);
    case RequestType.dpo:
      location = AppRoute.dpoRequestViewWithId(requestId);
  }
  context.push(location);
}
