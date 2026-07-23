import 'package:dio/dio.dart';

import '../../domain/vm_network_config.dart';

/// Attaches `Authorization: <scheme> <token>` when [tokenProvider] resolves a
/// non-null token. No header is added when there is no provider, or it
/// resolves to null (e.g. logged-out state).
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({required this.tokenProvider, required this.scheme});

  final VmAuthTokenProvider? tokenProvider;
  final String scheme;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final provider = tokenProvider;
    if (provider != null) {
      final token = await provider();
      if (token != null) {
        options.headers['Authorization'] = '$scheme $token';
      }
    }
    handler.next(options);
  }
}
