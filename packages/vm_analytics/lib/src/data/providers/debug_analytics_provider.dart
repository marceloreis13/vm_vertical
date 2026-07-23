// ignore_for_file: prefer_initializing_formals
// (the field is private for encapsulation; the constructor's named
// parameter must stay public, so a plain initializing formal isn't
// available here.)

import 'dart:async';
import 'dart:developer' as developer;

import '../../domain/analytics_call.dart';
import '../../domain/analytics_event.dart';
import '../../domain/analytics_provider.dart';

/// Built-in [AnalyticsProvider] that logs every call via `dart:developer`
/// (a seam earmarked for a future `vm_logging`) and exposes an
/// **observable** record of received calls — a broadcast [Stream] plus a
/// bounded [buffer] — so a UI (the `example/` visual demo) can render them
/// on-screen live, in the order they were received.
class DebugAnalyticsProvider implements AnalyticsProvider {
  DebugAnalyticsProvider({int bufferLimit = 200}) : _bufferLimit = bufferLimit;

  final int _bufferLimit;
  final List<AnalyticsCall> _buffer = [];
  final StreamController<AnalyticsCall> _controller =
      StreamController<AnalyticsCall>.broadcast();

  /// Calls received so far, oldest first, capped at `bufferLimit`.
  List<AnalyticsCall> get buffer => List.unmodifiable(_buffer);

  /// Emits each call as it is received, in order.
  Stream<AnalyticsCall> get calls => _controller.stream;

  @override
  Future<void> logEvent(AnalyticsEvent event) async =>
      _record(AnalyticsCall.logEvent(event));

  @override
  Future<void> setUserProperty(String name, Object? value) async =>
      _record(AnalyticsCall.setUserProperty(name: name, value: value));

  @override
  Future<void> screenView(String name) async =>
      _record(AnalyticsCall.screenView(name));

  @override
  Future<void> setUserId(String? id) async =>
      _record(AnalyticsCall.setUserId(id));

  @override
  Future<void> reset() async => _record(const AnalyticsCall.reset());

  void _record(AnalyticsCall call) {
    developer.log(call.describe(), name: 'vm_analytics.debug');
    _buffer.add(call);
    if (_buffer.length > _bufferLimit) {
      _buffer.removeAt(0);
    }
    if (!_controller.isClosed) {
      _controller.add(call);
    }
  }

  /// Releases the broadcast stream. Safe to call once the provider is no
  /// longer used (e.g. example app teardown).
  Future<void> dispose() => _controller.close();
}
