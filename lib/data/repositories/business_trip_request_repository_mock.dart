import 'package:hr_tcc/domain/entities/requests/business_trip_request.dart';
import 'package:hr_tcc/domain/repositories/business_trip_request_repository.dart';

class BusinessTripRequestRepositoryMock
    implements BusinessTripRequestRepository {
  final List<BusinessTripRequest> _storage = [];

  @override
  Future<void> create(BusinessTripRequest request) async {
    _storage.add(request);
  }

  @override
  Future<BusinessTripRequest?> getById(String id) async {
    try {
      return _storage.firstWhere((r) => r.id == id);
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Future<List<BusinessTripRequest>> getAll() async {
    return List.unmodifiable(_storage);
  }
}
