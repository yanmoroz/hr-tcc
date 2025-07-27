import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:flutter/material.dart';

// Типы отсутствия
enum AbsenceType {
  earlyLeave, // Ранний уход
  lateArrival, // Опоздание
  workSchedule, // График работы
  other, // Иное
}

extension AbsenceTypeExtension on AbsenceType {
  String get label {
    switch (this) {
      case AbsenceType.earlyLeave:
        return 'Ранний уход';
      case AbsenceType.lateArrival:
        return 'Опоздание';
      case AbsenceType.workSchedule:
        return 'График работы';
      case AbsenceType.other:
        return 'Иное';
    }
  }
}

// Поля заявки на отсутствие
enum AbsenceRequestField {
  type,
  date,
  period,
  time,
  timeRangeStart,
  timeRangeEnd,
  reason,
}

class AbsenceRequest {
  final String id;
  final AbsenceType type;
  final DateTime? date;
  final DateTimeRange? period;
  final TimeOfDay? time;
  final TimeOfDay? timeRangeStart;
  final TimeOfDay? timeRangeEnd;
  final String? reason;
  final RequestStatus status;
  final DateTime createdAt;

  AbsenceRequest({
    required this.id,
    required this.type,
    this.date,
    this.period,
    this.time,
    this.timeRangeStart,
    this.timeRangeEnd,
    this.reason,
    required this.status,
    required this.createdAt,
  });
}
