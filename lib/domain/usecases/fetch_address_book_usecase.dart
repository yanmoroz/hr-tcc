import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/models.dart';

class FetchAddressBookUseCase {
  final AdressBookRepository _adressBookRepository;

  FetchAddressBookUseCase(this._adressBookRepository);

  Future<List<EmployeeAdressBookModel>> call({
    required int page,
    required int pageSize,
    query
  }) async {
    return await _adressBookRepository.fetch(page: page, pageSize: pageSize, query: query);
  }
}