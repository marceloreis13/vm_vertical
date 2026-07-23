import 'package:dio/dio.dart';

import '../core/failure.dart';
import '../core/json_map.dart';
import '../core/result.dart';
import '../domain/vm_network_config.dart';
import '../domain/vm_http_client.dart';
import 'failure_translator.dart';
import 'interceptors/auth_token_interceptor.dart';
import 'interceptors/custom_interceptor_adapter.dart';
import 'interceptors/default_headers_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/offline_gate_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'logging/vm_network_logger.dart';

/// Dio-backed [VmHttpClient]. Dio is an implementation detail: no Dio type
/// appears in this class's public (inherited) signatures.
class VmDioHttpClient implements VmHttpClient {
  VmDioHttpClient(this._dio);

  /// Builds a fully-wired client from [config] directly (offline gate when
  /// configured, auth, default headers, custom interceptors, retry, logging
  /// — same chain as `registerVmNetworkModule`), for callers that need more
  /// than one independently-configured client (e.g. the visual example's
  /// timeout and retry demos) without going through GetIt.
  factory VmDioHttpClient.fromConfig(VmNetworkConfig config) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
      ),
    );
    final gate = config.gate;
    dio.interceptors.addAll([
      if (gate != null)
        OfflineGateInterceptor(gate: gate, policy: config.offlinePolicy),
      AuthTokenInterceptor(
        tokenProvider: config.tokenProvider,
        scheme: config.authScheme,
      ),
      DefaultHeadersInterceptor(defaultHeaders: config.defaultHeaders),
      for (final interceptor in config.customInterceptors)
        CustomInterceptorAdapter(interceptor),
      RetryInterceptor(dio: dio, policy: config.retryPolicy),
      LoggingInterceptor(
        logger: const DeveloperVmNetworkLogger(),
        enabled: config.enableLogging,
      ),
    ]);
    return VmDioHttpClient(dio);
  }

  final Dio _dio;

  /// Exposes the internal Dio instance for tests within this package only
  /// (not part of the barrel, so no Dio type leaks to consumers).
  Dio get debugDio => _dio;

  @override
  Future<Result<T, Failure>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  }) => _request('GET', path, query: query, headers: headers, decoder: decoder);

  @override
  Future<Result<T, Failure>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  }) => _request(
    'POST',
    path,
    body: body,
    query: query,
    headers: headers,
    decoder: decoder,
  );

  @override
  Future<Result<T, Failure>> put<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  }) => _request(
    'PUT',
    path,
    body: body,
    query: query,
    headers: headers,
    decoder: decoder,
  );

  @override
  Future<Result<T, Failure>> patch<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  }) => _request(
    'PATCH',
    path,
    body: body,
    query: query,
    headers: headers,
    decoder: decoder,
  );

  @override
  Future<Result<T, Failure>> delete<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  }) => _request(
    'DELETE',
    path,
    body: body,
    query: query,
    headers: headers,
    decoder: decoder,
  );

  @override
  Future<Result<JsonMap, Failure>> getRaw(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _request<JsonMap>(
    'GET',
    path,
    query: query,
    headers: headers,
    decoder: (json) => json as JsonMap,
  );

  @override
  Future<Result<List<JsonMap>, Failure>> getRawList(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _request<List<JsonMap>>(
    'GET',
    path,
    query: query,
    headers: headers,
    decoder: (json) => (json as List<dynamic>).cast<JsonMap>(),
  );

  Future<Result<T, Failure>> _request<T>(
    String method,
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required T Function(Object? json) decoder,
  }) async {
    final Response<dynamic> response;
    try {
      response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method, headers: headers),
      );
    } on DioException catch (exception) {
      return Err(translateDioException(exception));
    }

    try {
      return Success(decoder(response.data));
    } catch (exception) {
      return Err(
        ParsingFailure(
          message: 'Failed to decode response body: $exception',
          cause: exception,
        ),
      );
    }
  }
}
