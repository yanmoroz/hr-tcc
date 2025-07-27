import 'package:hr_tcc/domain/models/models.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class FeatchLinkContentUseCase {
  final LinkRepository _repository;

  FeatchLinkContentUseCase(this._repository);

  Future<LinkAction> call(String url) async {
    return await _repository(url);
  }
}
