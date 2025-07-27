import 'package:logger/logger.dart';

import '../../core/logging/app_logger.dart';

class AppLoggerImpl implements AppLogger {
  final Logger _logger;

  AppLoggerImpl({required Logger logger}) : _logger = logger;

  @override
  void i(String message) => _logger.i(message);

  @override
  void w(String message) => _logger.w(message);

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message);
}
