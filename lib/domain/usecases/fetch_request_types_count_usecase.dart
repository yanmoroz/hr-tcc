import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/domain/entities/requests/requests.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class FetchRequestTypesCountUseCase {
  final RequestTypesRepository repository;
  FetchRequestTypesCountUseCase(this.repository);

  Future<Map<RequestGroup, int>> call({String? query}) {
    return repository.fetchRequestTypesCountByGroup(query: query);
  }
}
