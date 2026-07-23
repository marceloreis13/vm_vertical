import 'offline_request_policy.dart';
import 'retry_policy.dart';
import 'vm_connectivity_gate.dart';
import 'vm_network_interceptor.dart';

/// Async provider resolving the current auth token, or `null` when logged
/// out. Supplied by the consuming app — the module never reads ambient state.
typedef VmAuthTokenProvider = Future<String?> Function();

/// Configuration for the `vm_network` module, always supplied by the
/// consuming app via `registerVmNetworkModule`. The module hard-codes no
/// app-specific endpoint or global state.
class VmNetworkConfig {
  const VmNetworkConfig({
    required this.baseUrl,
    this.defaultHeaders = const {},
    this.tokenProvider,
    this.authScheme = 'Bearer',
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
    this.sendTimeout = const Duration(seconds: 10),
    this.retryPolicy = const RetryPolicy(),
    this.enableLogging = false,
    this.customInterceptors = const [],
    this.gate,
    this.offlinePolicy = const OfflineRequestPolicy(),
  });

  final String baseUrl;
  final Map<String, String> defaultHeaders;

  /// When null, no `Authorization` header is ever attached.
  final VmAuthTokenProvider? tokenProvider;

  /// Scheme prefixed to the token, e.g. `Bearer <token>`.
  final String authScheme;

  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  final RetryPolicy retryPolicy;

  /// When false, the client emits no request/response logs.
  final bool enableLogging;

  /// Additional interceptors appended after auth/default-headers and before
  /// retry/logging, in the given order.
  final List<VmNetworkInterceptor> customInterceptors;

  /// Optional connectivity gate. When `null` (the default), the client
  /// issues requests with no offline gating, identical to prior behavior.
  final VmConnectivityGate? gate;

  /// Bounds how long a request may be held while [gate] reports offline.
  /// Only takes effect when [gate] is configured.
  final OfflineRequestPolicy offlinePolicy;
}
