import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/failure.dart';
import '../../domain/offline_request_policy.dart';
import '../../domain/vm_connectivity_gate.dart';

/// Holds outbound requests while [gate] reports offline and resumes them
/// once it reports online again, bounded by [policy]. Only added to the
/// interceptor chain when `VmNetworkConfig.gate` is configured (see
/// `VmDioHttpClient.fromConfig`), so absent-gate behavior is byte-for-byte
/// unchanged.
class OfflineGateInterceptor extends Interceptor {
  OfflineGateInterceptor({required this.gate, required this.policy});

  final VmConnectivityGate gate;
  final OfflineRequestPolicy policy;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (gate.isOnline) {
      handler.next(options);
      return;
    }

    try {
      await _waitForOnline();
      handler.next(options);
    } on TimeoutException {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: OfflineFailure(
            message:
                'Request held offline exceeded the policy bound of '
                '${policy.maxWait}',
          ),
        ),
      );
    }
  }

  Future<void> _waitForOnline() {
    if (gate.isOnline) return Future<void>.value();
    return gate.onlineChanges
        .firstWhere((online) => online)
        .timeout(policy.maxWait)
        .then((_) {});
  }
}
