import 'package:hr_tcc/domain/entities/requests/business_trip_request.dart';

abstract class BusinessTripRequestRepository {
  Future<void> create(BusinessTripRequest request);
  Future<BusinessTripRequest?> getById(String id);
  Future<List<BusinessTripRequest>> getAll();
}
