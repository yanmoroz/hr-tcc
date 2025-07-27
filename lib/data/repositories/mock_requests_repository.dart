import 'package:hr_tcc/domain/entities/requests/requests.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class MockRequestsRepository implements RequestsRepository {
  static final _mockData = [
    Request(
      id: 'work-cert-1',
      type: RequestType.workCertificate,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: RequestStatus.active,
    ),
    ...List.generate(
      49,
      (i) => Request(
        id: '$i',
        type: RequestType.values[i % RequestType.values.length],
        createdAt: DateTime.now().subtract(Duration(days: i)),
        status: _statuses[i % _statuses.length],
      ),
    ),
  ];

  static const _statuses = [
    RequestStatus.active,
    RequestStatus.approved,
    RequestStatus.rejected,
    RequestStatus.completed,
  ];

  @override
  Future<List<Request>> fetchRequests({
    int page = 1,
    int pageSize = 10,
    RequestStatus? status,
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var data = _mockData;
    if (status != null && status != RequestStatus.all) {
      data = data.where((r) => r.status == status).toList();
    }
    if (query != null && query.isNotEmpty) {
      data =
          data
              .where(
                (r) => r.type.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    if (start >= data.length) return [];
    return data.sublist(start, end > data.length ? data.length : end);
  }

  @override
  Future<Map<RequestStatus, int>> fetchRequestsCountByStatus({
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var data = _mockData;
    if (query != null && query.isNotEmpty) {
      data =
          data
              .where(
                (r) => r.type.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    final Map<RequestStatus, int> counts = {};
    for (final status in RequestStatus.values) {
      if (status == RequestStatus.all) continue;
      counts[status] = data.where((r) => r.status == status).length;
    }
    counts[RequestStatus.all] = data.length;
    return counts;
  }
}
