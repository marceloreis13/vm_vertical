import 'package:dio/dio.dart';

/// Merges configured default headers into every request. A header already
/// present on the request (a per-call override) wins over the default.
class DefaultHeadersInterceptor extends Interceptor {
  DefaultHeadersInterceptor({required this.defaultHeaders});

  final Map<String, String> defaultHeaders;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    for (final entry in defaultHeaders.entries) {
      options.headers.putIfAbsent(entry.key, () => entry.value);
    }
    handler.next(options);
  }
}
