import 'package:dio/dio.dart';

import '../../domain/retry_policy.dart';

/// Retries transient failures (network, timeout, and configured retriable
/// server statuses) according to [policy]. Never retries 401/403 or other
/// non-retriable client errors. Returns the last failure once attempts are
/// exhausted.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({required this.dio, required this.policy});

  final Dio dio;
  final RetryPolicy policy;

  static const _attemptKey = 'vm_network_retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;

    if (!_isRetriable(err) || attempt >= policy.maxAttempts - 1) {
      handler.next(err);
      return;
    }

    final nextAttempt = attempt + 1;
    await Future<void>.delayed(policy.backoff(nextAttempt));

    final retryOptions = options..extra[_attemptKey] = nextAttempt;

    try {
      final response = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isRetriable(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        return statusCode != null &&
            policy.retriableStatusCodes.contains(statusCode);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }
}
