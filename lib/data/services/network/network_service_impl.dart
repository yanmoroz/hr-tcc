import 'package:dio/dio.dart';
import 'package:hr_tcc/domain/repositories/access_token_repository.dart';
import 'package:hr_tcc/domain/services/network_service.dart';
import 'package:path_provider/path_provider.dart';

class NetworkServiceImpl implements NetworkService {
  final Dio _dio;
  final AccessTokenRepository _accessTokenRepository;

  static const Map<String, String> _defaultHeaders = {
    'content-type': 'application/json',
  };
  static const Duration _defaultTimeout = Duration(seconds: 30);

  NetworkServiceImpl(this._dio, this._accessTokenRepository) {
    _dio.options
      ..connectTimeout = _defaultTimeout
      ..sendTimeout = _defaultTimeout
      ..receiveTimeout = _defaultTimeout;
  }

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    final accessToken = await _accessTokenRepository.getAccessToken();
    final mergedHeaders = {
      ..._defaultHeaders,
      if (headers != null) ...headers,
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    return await _dio.post(
      path,
      data: data,
      options: Options(headers: mergedHeaders),
    );
  }

  @override
  Future<String> downloadFile(
    String url, {
    Map<String, dynamic>? headers,
  }) async {
    final name = Uri.parse(url).pathSegments.lastOrNull ?? 'file';
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$name';
    await _dio.download(url, path, options: Options(headers: headers));
    return path;
  }

  @override
  Future<String> fetchContentType(String url) async =>
      (await _dio.head(url)).headers.value('content-type') ?? '';
}
