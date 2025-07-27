import 'package:hr_tcc/domain/models/models.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubits/snackbar/snackbar_cubit.dart';

class LinkActionHelper {
  const LinkActionHelper._();

  // Основной метод для обработки ссылки
  static Future<void> onLinkTap(
    SnackBarCubit snackBarCubit,
    String url,
    FeatchLinkContentUseCase useCase,
  ) async {
    snackBarCubit.showSnackBar('Загрузка ....');

    LinkAction? action;
    try {
      action = await useCase(url);
    } on Exception catch (e) {
      snackBarCubit.showSnackBar('Не удалось обработать ссылку: $e');
      return;
    }

    await _performAction(snackBarCubit, action);
  }

  // Приватный метод для выполнения действия
  static Future<void> _performAction(
    SnackBarCubit snackBarCubit,
    LinkAction action,
  ) async {
    switch (action) {
      case LaunchBrowser(:final url):
        final ok = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
        if (!ok) {
          snackBarCubit.showSnackBar('Не удалось открыть браузер для: $url');
        }
        break;

      case OpenFileAction(:final path):
        final result = await OpenFilex.open(path);
        if (result.type != ResultType.done) {
          snackBarCubit.showSnackBar(
            'Не удалось открыть файл: ${result.message}',
          );
        }
        break;

      case ShowError():
        snackBarCubit.showSnackBar('Произошла ошибка при обработке ссылки');
        break;
    }
  }
}
