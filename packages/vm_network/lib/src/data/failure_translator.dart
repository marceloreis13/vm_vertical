import 'package:dio/dio.dart';

import '../core/failure.dart';
import '../core/json_map.dart';

/// Single translation point from Dio-level errors into the [Failure]
/// taxonomy. Never throws — unclassifiable errors fall back to
/// [UnknownFailure].
Failure translateDioException(DioException exception) {
  // An interceptor (e.g. the offline-gate) may attach an already-typed
  // Failure directly on the DioException; prefer it over type-based
  // classification.
  final attached = exception.error;
  if (attached is Failure) return attached;

  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return TimeoutFailure(
        message: 'Request timed out: ${exception.message}',
        cause: exception,
      );
    case DioExceptionType.connectionError:
      return NetworkFailure(
        message: 'No connectivity: ${exception.message}',
        cause: exception,
      );
    case DioExceptionType.badResponse:
      return _translateBadResponse(exception);
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return UnknownFailure(
        message: exception.message ?? 'Unknown network error',
        cause: exception,
      );
  }
}

Failure _translateBadResponse(DioException exception) {
  final statusCode = exception.response?.statusCode;
  if (statusCode == null) {
    return UnknownFailure(
      message: 'Bad response with no status code',
      cause: exception,
    );
  }
  if (statusCode == 401 || statusCode == 403) {
    return UnauthorizedFailure(
      message: 'Unauthorized (status $statusCode)',
      statusCode: statusCode,
      cause: exception,
    );
  }
  if (statusCode < 200 || statusCode >= 300) {
    return ServerFailure(
      message: 'Server error (status $statusCode)',
      statusCode: statusCode,
      payload: _asJsonMap(exception.response?.data),
      cause: exception,
    );
  }
  return UnknownFailure(
    message: 'Unclassified response (status $statusCode)',
    cause: exception,
  );
}

JsonMap? _asJsonMap(Object? data) => data is JsonMap ? data : null;
