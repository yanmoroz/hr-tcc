import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';

enum PassRequestField {
  type,
  legalEntity,
  purpose,
  floor,
  office,
  date,
  timeFrom,
  timeTo,
  visitors,
  otherPurpose,
  dateOfStart,
  photo,
  entryPoint,
  workRooms,
  equipmentList,
}

enum PassType { guest, permanent, overtime, contractor }

enum PassPurpose { meeting, interview, hiring, lost, other }

class Office {
  final String id;
  final String name;
  final List<int> floors;
  const Office({required this.id, required this.name, required this.floors});
}

class Organization {
  final String id;
  final String name;
  const Organization({required this.id, required this.name});
}

class PassRequest {
  final String id;
  final PassType type;
  final Organization legalEntity;
  final PassPurpose? purpose;
  final int floor;
  final Office office;
  final DateTimeRange? dateRange;
  final TimeOfDay? timeFrom;
  final TimeOfDay? timeTo;
  final List<dynamic> visitors;
  final String? otherPurpose;
  final DateTime? dateOfStart;
  final String? photo;
  final String? entryPoint;
  final RequestStatus status;
  final DateTime createdAt;

  PassRequest({
    required this.id,
    required this.type,
    required this.legalEntity,
    this.purpose,
    required this.floor,
    required this.office,
    this.dateRange,
    this.timeFrom,
    this.timeTo,
    required this.visitors,
    this.otherPurpose,
    this.dateOfStart,
    this.photo,
    this.entryPoint,
    required this.status,
    required this.createdAt,
  });
}

enum EntryPoint { debarkader, lobby }

extension EntryPointExtension on EntryPoint {
  String get label {
    switch (this) {
      case EntryPoint.debarkader:
        return 'Дебаркадер';
      case EntryPoint.lobby:
        return 'Лобби';
    }
  }
}

const entryPoints = EntryPoint.values;

const organizations = [
  Organization(id: 'tcc', name: 'ООО "ТСС"'),
  Organization(id: 'tcc_dev', name: 'ООО "ТСС Девелопмент"'),
  Organization(id: 'tcc_it', name: 'ООО "ТСС ИТ"'),
  Organization(id: 'tcc_service', name: 'ООО "ТСС Сервис"'),
];
