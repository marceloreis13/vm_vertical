// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/failure.dart';
import '../../core/json_map.dart';
import '../../core/result.dart';
import '../../domain/vm_http_client.dart';
import 'scenario_result.dart';

/// Scenario identifiers driven by [NetworkDemoScreen]'s Sections.
class DemoScenario {
  static const direct = 'direct';
  static const basicAuthOk = 'basicAuthOk';
  static const bearer = 'bearer';
  static const customInterceptor = 'customInterceptor';
  static const notFound = 'notFound';
  static const serverError = 'serverError';
  static const unauthorized = 'unauthorized';
  static const timeout = 'timeout';
  static const retry = 'retry';

  static const all = [
    direct,
    basicAuthOk,
    bearer,
    customInterceptor,
    notFound,
    serverError,
    unauthorized,
    timeout,
    retry,
  ];
}

String _basicAuthHeader(String user, String pass) =>
    'Basic ${base64Encode(utf8.encode('$user:$pass'))}';

/// Drives every scenario in the `vm_network` visual example. [sharedClient]
/// is the app-registered client (via `registerVmNetworkModule`), reused for
/// every scenario that only needs the base config. [timeoutClient] and
/// [retryClient] are separately configured (short receive timeout; a retry
/// policy that treats 500 as transient) so their demos have real, distinct
/// behavior to show — see `NetworkDemoScreen` for how they're built.
class NetworkDemoCubit extends Cubit<Map<String, ScenarioResult>> {
  NetworkDemoCubit({
    required VmHttpClient sharedClient,
    required VmHttpClient timeoutClient,
    required VmHttpClient retryClient,
  }) : _sharedClient = sharedClient,
       _timeoutClient = timeoutClient,
       _retryClient = retryClient,
       super({for (final id in DemoScenario.all) id: const ScenarioIdle()});

  final VmHttpClient _sharedClient;
  final VmHttpClient _timeoutClient;
  final VmHttpClient _retryClient;

  void _set(String id, ScenarioResult result) {
    emit({...state, id: result});
  }

  Future<void> _run(
    String id,
    Future<Result<Object?, Failure>> Function() action, {
    required String Function(Object? value) summarize,
  }) async {
    _set(id, const ScenarioLoading());
    final result = await action();
    result.when(
      success: (value) => _set(id, ScenarioSuccess(summary: summarize(value))),
      failure: (failure) => _set(id, ScenarioFailure(failure: failure)),
    );
  }

  Future<void> runDirect() => _run(
    DemoScenario.direct,
    () => _sharedClient.getRaw('/get'),
    summarize: (value) => 'GET /get succeeded: ${(value as JsonMap)['url']}',
  );

  Future<void> runBasicAuthOk() => _run(
    DemoScenario.basicAuthOk,
    () => _sharedClient.getRaw(
      '/basic-auth/demo/demo123',
      headers: {'Authorization': _basicAuthHeader('demo', 'demo123')},
    ),
    summarize: (value) =>
        'Authenticated as "${(value as JsonMap)['user']}" via Basic auth',
  );

  Future<void> runBearer() => _run(
    DemoScenario.bearer,
    () => _sharedClient.getRaw('/bearer'),
    summarize: (value) =>
        'Auth interceptor attached token: "${(value as JsonMap)['token']}"',
  );

  Future<void> runCustomInterceptor() => _run(
    DemoScenario.customInterceptor,
    () => _sharedClient.getRaw('/get'),
    summarize: (value) {
      final headers = (value as JsonMap)['headers'] as JsonMap?;
      final echoed = headers?['X-Vm-Demo-Header'] as String?;
      return echoed == null
          ? 'Request succeeded, but the custom header was not echoed back'
          : 'Custom interceptor header echoed back by the server: "$echoed"';
    },
  );

  Future<void> runNotFound() => _run(
    DemoScenario.notFound,
    () => _sharedClient.getRaw('/status/404'),
    summarize: (_) => 'unexpected success',
  );

  Future<void> runServerError() => _run(
    DemoScenario.serverError,
    () => _sharedClient.getRaw('/status/500'),
    summarize: (_) => 'unexpected success',
  );

  Future<void> runUnauthorized() => _run(
    DemoScenario.unauthorized,
    () => _sharedClient.getRaw(
      '/basic-auth/demo/demo123',
      headers: {'Authorization': _basicAuthHeader('demo', 'wrong-password')},
    ),
    summarize: (_) => 'unexpected success',
  );

  Future<void> runTimeout() => _run(
    DemoScenario.timeout,
    () => _timeoutClient.getRaw('/delay/3'),
    summarize: (_) => 'unexpected success',
  );

  Future<void> runRetry() async {
    _set(
      DemoScenario.retry,
      const ScenarioLoading(
        note: 'Retrying transient 5xx responses (up to 3 attempts)...',
      ),
    );
    final result = await _retryClient.getRaw('/status/500');
    result.when(
      success: (value) => _set(
        DemoScenario.retry,
        const ScenarioSuccess(summary: 'Succeeded after retrying'),
      ),
      failure: (failure) =>
          _set(DemoScenario.retry, ScenarioFailure(failure: failure)),
    );
  }
}
