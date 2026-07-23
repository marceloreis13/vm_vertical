import '../../domain/logger.dart';

/// Optional HTTP request/response logging adapter. Operates over **plain
/// data** (method, url, status, headers, duration) passed by the caller —
/// it imports nothing from `vm_network` and no `vm_*` type appears in its
/// signature, so `vm_logging` carries no hard `vm_*` dependency. An app (or
/// a future `vm_network` interceptor) wires this only if it wants network
/// logging; `vm_logging` functions fully without it.
///
/// Entries produced here flow through the same [Logger] call the adapter is
/// given, so they pass through the same redaction pipeline as any other
/// entry — a sensitive header (e.g. `authorization`) configured as a
/// sensitive key is masked before delivery, like any other field.
class NetworkLogAdapter {
  const NetworkLogAdapter(this._logger);

  final Logger _logger;

  /// Logs one HTTP exchange. [statusCode]/[error] decide the level: a
  /// transport [error] or a `5xx` status logs at `error`; a `4xx` status
  /// logs at `warn`; anything else logs at `info`.
  void logExchange({
    required String method,
    required String url,
    int? statusCode,
    Map<String, String> headers = const {},
    Duration? duration,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final fields = <String, Object?>{
      'method': method,
      'url': url,
      if (statusCode != null) 'statusCode': statusCode,
      if (headers.isNotEmpty) 'headers': headers,
      if (duration != null) 'durationMs': duration.inMilliseconds,
    };
    final message =
        '$method $url'
        '${statusCode == null ? '' : ' -> $statusCode'}';

    if (error != null || (statusCode != null && statusCode >= 500)) {
      _logger.error(
        message,
        fields: fields,
        error: error,
        stackTrace: stackTrace,
      );
    } else if (statusCode != null && statusCode >= 400) {
      _logger.warn(message, fields: fields);
    } else {
      _logger.info(message, fields: fields);
    }
  }
}
