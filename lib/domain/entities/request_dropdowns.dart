import 'pass_request.dart';
import 'requests/business_trip_request.dart';

const offices = [
  Office(id: 'avilon', name: 'Авилон', floors: [1, 2, 4, 6, 8, 10, 12, 17]),
  Office(id: 'gs_msk', name: 'Город Столиц (Москва)', floors: [7]),
  Office(id: 'gs_spb', name: 'Город Столиц (Санкт-Петербург)', floors: [10]),
  Office(id: 'oko', name: 'ОКО', floors: [42, 43]),
];

const purposes = [
  PassPurpose.meeting,
  PassPurpose.interview,
  PassPurpose.hiring,
  PassPurpose.lost,
  PassPurpose.other,
];

String passPurposeLabel(PassPurpose purpose) {
  switch (purpose) {
    case PassPurpose.meeting:
      return 'Совещание';
    case PassPurpose.interview:
      return 'Собеседование';
    case PassPurpose.hiring:
      return 'Устройство на работу';
    case PassPurpose.lost:
      return 'Забыл/потерял постоянный пропуск';
    case PassPurpose.other:
      return 'Иное';
  }
}

const businessTripCities = [
  BusinessTripCity.moscow,
  BusinessTripCity.spb,
  BusinessTripCity.kazan,
  BusinessTripCity.ekb,
  BusinessTripCity.other,
];

String businessTripCityLabel(BusinessTripCity city) {
  switch (city) {
    case BusinessTripCity.moscow:
      return 'Москва';
    case BusinessTripCity.spb:
      return 'Санкт-Петербург';
    case BusinessTripCity.kazan:
      return 'Казань';
    case BusinessTripCity.ekb:
      return 'Екатеринбург';
    case BusinessTripCity.other:
      return 'Другой';
  }
}

const businessTripAccounts = [
  BusinessTripAccount.company,
  BusinessTripAccount.self,
  BusinessTripAccount.other,
];
String businessTripAccountLabel(BusinessTripAccount acc) {
  switch (acc) {
    case BusinessTripAccount.company:
      return 'За счёт компании';
    case BusinessTripAccount.self:
      return 'За свой счёт';
    case BusinessTripAccount.other:
      return 'Другое';
  }
}

const businessTripPurposes = [
  BusinessTripPurpose.purpose1,
  BusinessTripPurpose.purpose2,
  BusinessTripPurpose.other,
];
String businessTripPurposeLabel(BusinessTripPurpose p) {
  switch (p) {
    case BusinessTripPurpose.purpose1:
      return 'Цель 1';
    case BusinessTripPurpose.purpose2:
      return 'Цель 2';
    case BusinessTripPurpose.other:
      return 'Другое';
  }
}

const businessTripActivities = [
  BusinessTripActivity.activity1,
  BusinessTripActivity.activity2,
  BusinessTripActivity.other,
];
String businessTripActivityLabel(BusinessTripActivity a) {
  switch (a) {
    case BusinessTripActivity.activity1:
      return 'Деятельность 1';
    case BusinessTripActivity.activity2:
      return 'Деятельность 2';
    case BusinessTripActivity.other:
      return 'Другое';
  }
}

const travelCoordinatorServices = [
  TravelCoordinatorService.required,
  TravelCoordinatorService.notRequired,
];
String travelCoordinatorServiceLabel(TravelCoordinatorService s) {
  switch (s) {
    case TravelCoordinatorService.required:
      return 'Требуется';
    case TravelCoordinatorService.notRequired:
      return 'Не требуется';
  }
}
