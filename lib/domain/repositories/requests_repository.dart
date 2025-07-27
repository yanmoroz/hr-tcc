import '../entities/requests/requests.dart';

abstract class RequestsRepository {
  Future<List<Request>> fetchRequests({
    int page = 1,
    int pageSize = 10,
    RequestStatus? status,
    String? query,
  });

  Future<Map<RequestStatus, int>> fetchRequestsCountByStatus({String? query});
}
