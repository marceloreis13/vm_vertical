import 'package:dio/dio.dart';

import '../logging/vm_network_logger.dart';

const _redactedHeaders = {'authorization'};

/// Logs request/response metadata via the [VmNetworkLogger] seam when
/// [enabled], redacting sensitive header values. Emits nothing when disabled.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required this.logger, required this.enabled});

  final VmNetworkLogger logger;
  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      logger.log(
        '--> ${options.method} ${options.uri} headers=${_redact(options.headers)}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (enabled) {
      logger.log('<-- ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      logger.log('<-- error ${err.requestOptions.uri}: ${err.message}');
    }
    handler.next(err);
  }

  Map<String, dynamic> _redact(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      if (_redactedHeaders.contains(key.toLowerCase())) {
        return MapEntry(key, '***redacted***');
      }
      return MapEntry(key, value);
    });
  }
}
