import 'package:hr_tcc/domain/repositories/repositories.dart';

class FetchAddressBookTotalCountUseCase {
  final AdressBookRepository _adressBookRepository;

  FetchAddressBookTotalCountUseCase(this._adressBookRepository);

  Future<int> call() async {
    return await _adressBookRepository.totalCount();
  }
}