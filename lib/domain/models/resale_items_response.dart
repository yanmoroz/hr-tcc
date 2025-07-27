import 'package:hr_tcc/models/models.dart';

class ResaleItemsResponse {
  final List<ResaleItemModel> onSale;
  final List<ResaleItemModel> reserved;

  ResaleItemsResponse({required this.onSale, required this.reserved});
}
