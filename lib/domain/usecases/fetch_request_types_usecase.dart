import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class FetchRequestTypesUseCase {
  final RequestTypesRepository repository;
  FetchRequestTypesUseCase(this.repository);

  Future<List<RequestTypeInfo>> call({RequestGroup? group, String? query}) {
    return repository.fetchRequestTypes(group: group, query: query);
  }
}
