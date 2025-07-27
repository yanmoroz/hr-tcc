import 'package:hr_tcc/domain/entities/requests/absence_request.dart';
import 'package:hr_tcc/domain/repositories/absence_request_repository.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:flutter/material.dart';

class AbsenceRequestRepositoryMock implements AbsenceRequestRepository {
  static final AbsenceRequestRepositoryMock instance =
      AbsenceRequestRepositoryMock._internal();
  final List<AbsenceRequest> _requests = [];

  AbsenceRequestRepositoryMock._internal() {
    if (_requests.isEmpty) {
      _generateMockRequests();
    }
  }
  factory AbsenceRequestRepositoryMock() => instance;

  void _generateMockRequests() {
    for (int i = 0; i < 10; i++) {
      final type = AbsenceType.values[i % AbsenceType.values.length];
      AbsenceRequest req;
      switch (type) {
        case AbsenceType.earlyLeave:
          req = AbsenceRequest(
            id: 'absence-$i',
            type: type,
            date: DateTime.now().subtract(Duration(days: i)),
            period: null,
            time: const TimeOfDay(hour: 17, minute: 0),
            timeRangeStart: null,
            timeRangeEnd: null,
            reason: 'Причина отсутствия $i',
            status:
                RequestStatus.values[(i % (RequestStatus.values.length - 1)) +
                    1],
            createdAt: DateTime.now().subtract(Duration(days: i)),
          );
          break;
        case AbsenceType.lateArrival:
          req = AbsenceRequest(
            id: 'absence-$i',
            type: type,
            date: DateTime.now().subtract(Duration(days: i)),
            period: null,
            time: const TimeOfDay(hour: 10, minute: 30),
            timeRangeStart: null,
            timeRangeEnd: null,
            reason: 'Причина отсутствия $i',
            status:
                RequestStatus.values[(i % (RequestStatus.values.length - 1)) +
                    1],
            createdAt: DateTime.now().subtract(Duration(days: i)),
          );
          break;
        case AbsenceType.workSchedule:
          req = AbsenceRequest(
            id: 'absence-$i',
            type: type,
            date: null,
            period: DateTimeRange(
              start: DateTime.now().subtract(Duration(days: i + 2)),
              end: DateTime.now().subtract(Duration(days: i)),
            ),
            time: null,
            timeRangeStart: const TimeOfDay(hour: 9, minute: 0),
            timeRangeEnd: const TimeOfDay(hour: 18, minute: 0),
            reason: 'Причина отсутствия $i',
            status:
                RequestStatus.values[(i % (RequestStatus.values.length - 1)) +
                    1],
            createdAt: DateTime.now().subtract(Duration(days: i)),
          );
          break;
        case AbsenceType.other:
          req = AbsenceRequest(
            id: 'absence-$i',
            type: type,
            date: DateTime.now().subtract(Duration(days: i)),
            period: null,
            time: null,
            timeRangeStart: null,
            timeRangeEnd: null,
            reason: 'Причина отсутствия $i',
            status:
                RequestStatus.values[(i % (RequestStatus.values.length - 1)) +
                    1],
            createdAt: DateTime.now().subtract(Duration(days: i)),
          );
      }
      _requests.add(req);
    }
  }

  @override
  Future<void> createAbsenceRequest(AbsenceRequest request) async {
    _requests.add(request);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<AbsenceRequest> getAbsenceRequestById(String id) async {
    return _requests.firstWhere(
      (r) => r.id == id,
      orElse:
          () =>
              _requests.isNotEmpty
                  ? _requests.first
                  : AbsenceRequest(
                    id: 'mock-default',
                    type: AbsenceType.earlyLeave,
                    date: DateTime.now(),
                    period: null,
                    time: const TimeOfDay(hour: 17, minute: 0),
                    timeRangeStart: null,
                    timeRangeEnd: null,
                    reason: 'Мок-заявка по умолчанию',
                    status: RequestStatus.newRequest,
                    createdAt: DateTime.now(),
                  ),
    );
  }

  @override
  Future<List<AbsenceRequest>> getAllAbsenceRequests() async {
    return List.unmodifiable(_requests);
  }
}
