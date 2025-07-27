import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/domain/models/models.dart';


class FetchResaleItemsUseCase {
  final ResaleRepository _repository;

  const FetchResaleItemsUseCase(this._repository);

  Future<ResaleItemsResponse> call() => _repository.fetchResaleItems();
}