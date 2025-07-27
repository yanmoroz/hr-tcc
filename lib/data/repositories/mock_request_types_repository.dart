import 'package:hr_tcc/domain/entities/requests/requests.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class MockRequestTypesRepository implements RequestTypesRepository {
  static const allRequestTypeInfos = [
    RequestTypeInfo(type: RequestType.pass, group: RequestGroup.office),
    RequestTypeInfo(type: RequestType.parking, group: RequestGroup.office),
    RequestTypeInfo(type: RequestType.absence, group: RequestGroup.hr),
    RequestTypeInfo(type: RequestType.violation, group: RequestGroup.regime),
    RequestTypeInfo(type: RequestType.businessTrip, group: RequestGroup.hr),
    RequestTypeInfo(type: RequestType.referralProgram, group: RequestGroup.hr),
    RequestTypeInfo(type: RequestType.taxCertificate, group: RequestGroup.hr),
    RequestTypeInfo(type: RequestType.workBookCopy, group: RequestGroup.hr),
    RequestTypeInfo(type: RequestType.workCertificate, group: RequestGroup.hr),
    RequestTypeInfo(
      type: RequestType.internalTraining,
      group: RequestGroup.education,
    ),
    RequestTypeInfo(
      type: RequestType.unplannedTraining,
      group: RequestGroup.education,
    ),
    RequestTypeInfo(type: RequestType.dpo, group: RequestGroup.education),
    RequestTypeInfo(
      type: RequestType.alpinaAccess,
      group: RequestGroup.corporate,
    ),
    RequestTypeInfo(
      type: RequestType.courierDelivery,
      group: RequestGroup.corporate,
    ),
  ];

  @override
  Future<List<RequestTypeInfo>> fetchRequestTypes({
    RequestGroup? group,
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var data = allRequestTypeInfos;
    if (group != null && group != RequestGroup.all) {
      data = data.where((t) => t.group == group).toList();
    }
    if (query != null && query.isNotEmpty) {
      data =
          data
              .where(
                (t) => t.type.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    return data;
  }

  @override
  Future<Map<RequestGroup, int>> fetchRequestTypesCountByGroup({
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var data = allRequestTypeInfos;
    if (query != null && query.isNotEmpty) {
      data =
          data
              .where(
                (t) => t.type.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    final Map<RequestGroup, int> counts = {};
    for (final group in RequestGroup.values) {
      if (group == RequestGroup.all) continue;
      counts[group] = data.where((t) => t.group == group).length;
    }
    counts[RequestGroup.all] = data.length;
    return counts;
  }
}
