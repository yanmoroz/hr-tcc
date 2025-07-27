import '../entities/parking_request.dart';
import 'parking_request_repository.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import '../entities/pass_request.dart';

class ParkingRequestRepositoryMock implements ParkingRequestRepository {
  final List<ParkingRequest> _requests = [];

  @override
  Future<List<ParkingRequest>> getAll() async => _requests;

  @override
  Future<ParkingRequest?> getById(String id) async {
    final found = _requests.firstWhere(
      (r) => r.id == id,
      orElse:
          () => ParkingRequest(
            id: id,
            type: ParkingType.guest,
            purpose: PassPurpose.meeting,
            floor: 1,
            office: const Office(
              id: 'avilon',
              name: 'Авилон',
              floors: [1, 2, 4, 6, 8, 10, 12, 17],
            ),
            carBrand: 'BMW',
            carNumber: 'A 777 AA / 777',
            dateRange: DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 1)),
            ),
            timeFrom: const TimeOfDay(hour: 8, minute: 0),
            timeTo: const TimeOfDay(hour: 17, minute: 0),
            visitors: const ['Гребенников Владимир Александрович'],
            parkingPlaceNumber: 'A-12',
            purposeText: 'Встреча с клиентом',
            cargoReason: 'Доставка оборудования',
            cargoDescription: 'Компьютерная техника, 3 коробки',
            driver: 'Иванов Иван',
            escort: 'Петров Петр',
            liftAction: 'Подъем',
            liftNumber: 6,
            status: RequestStatus.completed,
            createdAt: DateTime.now(),
          ),
    );
    return found;
  }

  @override
  Future<void> create(ParkingRequest request) async {
    _requests.add(request);
  }
}
