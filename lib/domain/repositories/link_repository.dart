import 'package:hr_tcc/domain/models/models.dart';

abstract class LinkRepository {
  Future<LinkAction> call(String url);
}
