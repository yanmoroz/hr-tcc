import '../entities/pass_request.dart';
import 'pass_request_repository.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';

class PassRequestRepositoryMock implements PassRequestRepository {
  final List<PassRequest> _requests = [];

  @override
  Future<List<PassRequest>> getAll() async => _requests;

  @override
  Future<PassRequest?> getById(String id) async {
    final found = _requests.firstWhere(
      (r) => r.id == id,
      orElse:
          () => PassRequest(
            id: id,
            type: PassType.guest,
            legalEntity: const Organization(id: 'org1', name: 'Организация 1'),
            purpose: PassPurpose.meeting,
            floor: 1,
            office: const Office(
              id: 'avilon',
              name: 'Авилон',
              floors: [1, 2, 4, 6, 8, 10, 12, 17],
            ),
            dateRange: DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 1)),
            ),
            timeFrom: const TimeOfDay(hour: 8, minute: 0),
            timeTo: const TimeOfDay(hour: 17, minute: 0),
            visitors: const ['Иванов Иван Иванович'],
            otherPurpose: null,
            dateOfStart: null,
            photo: null,
            entryPoint: null,
            status: RequestStatus.completed,
            createdAt: DateTime.now(),
          ),
    );
    return found;
  }

  @override
  Future<void> create(PassRequest request) async {
    _requests.add(
      PassRequest(
        id: request.id,
        type: request.type,
        legalEntity: request.legalEntity,
        purpose: request.purpose,
        floor: request.floor,
        office: request.office,
        dateRange: request.dateRange,
        timeFrom: request.timeFrom,
        timeTo: request.timeTo,
        visitors: request.visitors,
        otherPurpose: request.otherPurpose,
        dateOfStart: request.dateOfStart,
        photo: request.photo,
        entryPoint: request.entryPoint,
        status: request.status,
        createdAt: request.createdAt,
      ),
    );
  }
}
