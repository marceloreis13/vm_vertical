import 'package:dio/dio.dart';

import '../../domain/vm_network_interceptor.dart';

/// Adapts a consumer-supplied [VmNetworkInterceptor] (which never sees Dio)
/// onto Dio's [Interceptor] so it can be inserted into the request chain.
class CustomInterceptorAdapter extends Interceptor {
  CustomInterceptorAdapter(this._delegate);

  final VmNetworkInterceptor _delegate;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final context = VmRequestContext(
      method: options.method,
      path: options.path,
      headers: options.headers.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      query: options.queryParameters,
      body: options.data,
    );
    await _delegate.onRequest(context);
    options.headers
      ..clear()
      ..addAll(context.headers);
    handler.next(options);
  }
}
