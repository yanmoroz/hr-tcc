import '../models/requests/alpina_digital_access_request_models.dart';

abstract class AlpinaDigitalAccessRequestRepository {
  Future<AlpinaDigitalAccessRequest> fetchRequestDetails(String id);
  // Можно добавить методы для создания, обновления и т.д.
}
