import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/domain/entities/requests/requests.dart';

abstract class RequestTypesRepository {
  Future<List<RequestTypeInfo>> fetchRequestTypes({
    RequestGroup? group,
    String? query,
  });

  Future<Map<RequestGroup, int>> fetchRequestTypesCountByGroup({String? query});
}
