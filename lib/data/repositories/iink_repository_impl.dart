import 'package:hr_tcc/domain/models/link_action.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/domain/services/network_service.dart';

class LinkRepositoryImpl implements LinkRepository {
  const LinkRepositoryImpl(this._networkService);
  final NetworkService _networkService;

  @override
  Future<LinkAction> call(String url) async {
    try {
      final ct = await _networkService.fetchContentType(url);

      if (ct.contains('text/html')) return LaunchBrowser(url);

      if (ct.isNotEmpty) {
        final path = await _networkService.downloadFile(
          url,
          headers: {'Content-Type': 'application/json'},
        );
        return OpenFileAction(path);
      }

      return const ShowError('Не удалось определить тип контента');
    } on Exception catch (e) {
      return ShowError('Ошибка: $e');
    }
  }
}
