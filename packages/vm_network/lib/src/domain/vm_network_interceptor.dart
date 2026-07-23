/// Mutable view of an outgoing request, passed to [VmNetworkInterceptor]s.
/// Deliberately not a transport type — interceptors never see Dio.
class VmRequestContext {
  VmRequestContext({
    required this.method,
    required this.path,
    required this.headers,
    this.query,
    this.body,
  });

  final String method;
  final String path;

  /// Mutable: interceptors add/replace entries directly on this map.
  final Map<String, String> headers;
  final Map<String, dynamic>? query;
  final Object? body;
}

/// Consumer-supplied interceptor abstraction. The Dio-backed client adapts
/// these internally so custom app behavior (correlation IDs, tenant routing,
/// metrics, ...) plugs in without the app ever importing a Dio type.
///
/// Runs after the built-in auth/default-headers interceptors and before
/// retry/logging, in the order supplied in `VmNetworkConfig.customInterceptors`.
abstract class VmNetworkInterceptor {
  const VmNetworkInterceptor();

  Future<void> onRequest(VmRequestContext request);
}
