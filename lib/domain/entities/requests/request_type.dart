import 'package:hr_tcc/domain/entities/requests/requests.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

enum RequestType {
  pass,
  parking,
  absence,
  violation,
  businessTrip,
  referralProgram,
  taxCertificate,
  workBookCopy,
  workCertificate,
  internalTraining,
  unplannedTraining,
  dpo,
  alpinaAccess,
  courierDelivery,
}

extension RequestTypeExtension on RequestType {
  String get name {
    switch (this) {
      case RequestType.pass:
        return 'Пропуск';
      case RequestType.parking:
        return 'Парковка';
      case RequestType.absence:
        return 'Отсутствие';
      case RequestType.violation:
        return 'Нарушение';
      case RequestType.businessTrip:
        return 'Командировка';
      case RequestType.referralProgram:
        return 'Реферальная программа';
      case RequestType.taxCertificate:
        return 'Справка 2-НДФЛ';
      case RequestType.workBookCopy:
        return 'Копия трудовой книжки';
      case RequestType.workCertificate:
        return 'Справка с места работы';
      case RequestType.internalTraining:
        return 'Внутреннее обучение';
      case RequestType.unplannedTraining:
        return 'Незапланированное обучение';
      case RequestType.dpo:
        return 'ДПО';
      case RequestType.alpinaAccess:
        return 'Доступ к Альпина Диджитал';
      case RequestType.courierDelivery:
        return 'Курьерская доставка';
    }
  }

  String get icon {
    switch (this) {
      case RequestType.pass:
        return Assets.icons.requests.requestPass.path;
      case RequestType.parking:
        return Assets.icons.requests.requestParking.path;
      case RequestType.absence:
        return Assets.icons.requests.requestAbsence.path;
      case RequestType.violation:
        return Assets.icons.requests.requestViolation.path;
      case RequestType.businessTrip:
        return Assets.icons.requests.requestBusinessTrip.path;
      case RequestType.referralProgram:
        return Assets.icons.requests.requestReferral.path;
      case RequestType.taxCertificate:
        return Assets.icons.requests.taxCertificate.path;
      case RequestType.workBookCopy:
        return Assets.icons.requests.requestWorkBookCopy.path;
      case RequestType.workCertificate:
        return Assets.icons.requests.requestWorkCertificate.path;
      case RequestType.internalTraining:
        return Assets.icons.requests.requestInternalTraining.path;
      case RequestType.unplannedTraining:
        return Assets.icons.requests.requestUnplannedTraining.path;
      case RequestType.dpo:
        return Assets.icons.requests.requestDpo.path;
      case RequestType.alpinaAccess:
        return Assets.icons.requests.requestAlpinaAccess.path;
      case RequestType.courierDelivery:
        return Assets.icons.requests.requestCourier.path;
    }
  }
}

class RequestTypeInfo {
  final RequestType type;
  final RequestGroup group;

  const RequestTypeInfo({required this.type, required this.group});
}
