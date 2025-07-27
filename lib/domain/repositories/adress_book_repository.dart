import 'package:hr_tcc/models/models.dart';

abstract class AdressBookRepository {
  Future<List<EmployeeAdressBookModel>> fetch({
    required int page,
    required int pageSize,
    String query = '',
  });

  Future<int> totalCount();
}
