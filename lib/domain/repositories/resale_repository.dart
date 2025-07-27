import 'package:hr_tcc/domain/models/models.dart';

abstract class ResaleRepository {
  Future<ResaleItemsResponse> fetchResaleItems();
}