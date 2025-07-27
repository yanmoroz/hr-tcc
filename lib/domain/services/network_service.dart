import 'package:dio/dio.dart';

abstract class NetworkService {
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  });

  Future<String> downloadFile(String url, {Map<String, dynamic>? headers});

  Future<String> fetchContentType(String url);
}
