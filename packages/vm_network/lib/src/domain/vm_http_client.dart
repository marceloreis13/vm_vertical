import '../core/failure.dart';
import '../core/json_map.dart';
import '../core/result.dart';

/// Generic REST HTTP client. Hides the underlying transport (Dio) entirely —
/// no method signature, parameter, or return type references a transport
/// type. Every method resolves [path] against the injected `baseUrl` and
/// returns a [Result], never throwing on transport or protocol errors.
abstract class VmHttpClient {
  Future<Result<T, Failure>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  });

  Future<Result<T, Failure>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  });

  Future<Result<T, Failure>> put<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  });

  Future<Result<T, Failure>> patch<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  });

  Future<Result<T, Failure>> delete<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  });

  /// Raw GET returning the undecoded JSON object body, for schema-less
  /// responses.
  Future<Result<JsonMap, Failure>> getRaw(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  /// Raw GET returning the undecoded JSON array body.
  Future<Result<List<JsonMap>, Failure>> getRawList(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });
}
