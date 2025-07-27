import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'pass_request.dart';

enum ParkingType { guest, cargo, reserved }

enum ParkingRequestField {
  type,
  purpose,
  floor,
  office,
  carBrand,
  carNumber,
  date,
  timeFrom,
  timeTo,
  visitors,
  parkingPlaceNumber,
  purposeText,
  cargoReason,
  cargoDescription,
  driver,
  escort,
  liftAction,
  liftNumber,
}

class ParkingRequest {
  final String id;
  final ParkingType type;
  final PassPurpose purpose;
  final int floor;
  final Office office;
  final String carBrand;
  final String carNumber;
  final DateTimeRange dateRange;
  final TimeOfDay timeFrom;
  final TimeOfDay timeTo;
  final List<String> visitors;
  final String? parkingPlaceNumber;
  final String? purposeText;
  final String? cargoReason;
  final String? cargoDescription;
  final String? driver;
  final String? escort;
  final String? liftAction;
  final int? liftNumber;
  final RequestStatus status;
  final DateTime createdAt;

  ParkingRequest({
    required this.id,
    required this.type,
    required this.purpose,
    required this.floor,
    required this.office,
    required this.carBrand,
    required this.carNumber,
    required this.dateRange,
    required this.timeFrom,
    required this.timeTo,
    required this.visitors,
    this.parkingPlaceNumber,
    this.purposeText,
    this.cargoReason,
    this.cargoDescription,
    this.driver,
    this.escort,
    this.liftAction,
    this.liftNumber,
    required this.status,
    required this.createdAt,
  });
}
