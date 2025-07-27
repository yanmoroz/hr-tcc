import 'package:url_launcher/url_launcher.dart';

enum ExternalActionType {
  phone(scheme: 'tel', errorMessage: 'Не удалось открыть звонилку'),
  email(scheme: 'mailto', errorMessage: 'Не удалось открыть почтовый клиент');

  final String scheme;
  final String errorMessage;

  const ExternalActionType({required this.scheme, required this.errorMessage});

  /// Возвращает null, если не удалось определить тип
  static ExternalActionType? detect(String value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (emailRegex.hasMatch(value)) {
      return ExternalActionType.email;
    }

    // Обрезаем по запятой/точке с запятой/слешу, если есть добавочный
    final baseValue = value.split(RegExp(r'[;,\/]')).first.trim();

    // Нормализуем основной номер
    final normalized = baseValue
        .replaceAll(RegExp(r'[\s\-\u2010-\u2015\u2212]+'), '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    final phoneRegex = RegExp(r'^\+?\d{5,}$');

    if (phoneRegex.hasMatch(normalized)) {
      return ExternalActionType.phone;
    }

    return null;
  }
}

class ExternalActionResult {
  final bool success;
  final String? errorMessage;

  const ExternalActionResult._({required this.success, this.errorMessage});

  factory ExternalActionResult.success() =>
      const ExternalActionResult._(success: true);

  factory ExternalActionResult.error(String message) =>
      ExternalActionResult._(success: false, errorMessage: message);
}

class ExternalActionHelper {
  const ExternalActionHelper._();

  static Future<ExternalActionResult> open(String value) async {
    final actionType = ExternalActionType.detect(value);

    if (actionType == null) {
      return ExternalActionResult.error('Не удалось определить тип контакта');
    }

    final Uri uri = Uri(scheme: actionType.scheme, path: value);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return ExternalActionResult.success();
    } else {
      return ExternalActionResult.error(actionType.errorMessage);
    }
  }
}
