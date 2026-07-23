// ignore_for_file: prefer_initializing_formals
// (the field is private for encapsulation; the constructor's named
// parameter must stay public, so a plain initializing formal isn't
// available here.)

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/providers/debug_analytics_provider.dart';
import '../../domain/analytics_call.dart';
import '../../domain/analytics_event.dart';
import '../../domain/analytics_tracker.dart';

/// Drives the `vm_analytics` visual example: dispatches sample events, user
/// properties and identity calls through the app-registered
/// [AnalyticsTracker], and mirrors the calls the [DebugAnalyticsProvider]
/// actually received, so the screen can render exactly what was delivered,
/// in order.
class AnalyticsDemoCubit extends Cubit<List<AnalyticsCall>> {
  AnalyticsDemoCubit({
    required AnalyticsTracker tracker,
    required DebugAnalyticsProvider debugProvider,
  }) : _tracker = tracker,
       super(const []) {
    _subscription = debugProvider.calls.listen(
      (call) => emit([...state, call]),
    );
  }

  final AnalyticsTracker _tracker;
  StreamSubscription<AnalyticsCall>? _subscription;

  void emitViewedProduct() => unawaited(
    _tracker.logEvent(
      AnalyticsEvent(
        name: 'viewed_product',
        parameters: const {'sku': 'SKU-123', 'price': 42.5},
      ),
    ),
  );

  void emitCheckoutStarted() => unawaited(
    _tracker.logEvent(
      AnalyticsEvent(
        name: 'checkout_started',
        parameters: const {'item_count': 3},
      ),
    ),
  );

  void setSamplePlanProperty() =>
      unawaited(_tracker.setUserProperty('plan', 'pro'));

  void setSampleUserId() => unawaited(_tracker.setUserId('demo-user-42'));

  void clearUserId() => unawaited(_tracker.setUserId(null));

  void resetIdentity() => unawaited(_tracker.reset());

  @override
  Future<void> close() {
    unawaited(_subscription?.cancel());
    return super.close();
  }
}
