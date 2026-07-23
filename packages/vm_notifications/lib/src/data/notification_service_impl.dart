// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import '../core/notification_failure.dart';
import '../core/result.dart';
import '../core/unit.dart';
import '../domain/local_scheduler.dart';
import '../domain/notification_payload.dart';
import '../domain/notification_router.dart';
import '../domain/notification_service.dart';
import '../domain/push_provider.dart';
import 'debug/notification_debug_log.dart';

/// [NotificationService] implementation orchestrating a [PushProvider] and a
/// [LocalScheduler]: unifies token access and the message stream, enforces
/// the [NotificationEnabledGate] before scheduling/tap handling, invokes the
/// injected [NotificationRouter] on tap (isolating a faulty handler), and
/// maps provider exceptions to a typed [NotificationFailure] rather than
/// throwing into the call site.
class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl({
    required PushProvider pushProvider,
    required LocalScheduler localScheduler,
    required NotificationRouter router,
    NotificationEnabledGate? enabled,
    NotificationDebugLog debugLog = const DeveloperNotificationDebugLog(),
  }) : _pushProvider = pushProvider,
       _localScheduler = localScheduler,
       _router = router,
       _enabled = enabled ?? _alwaysEnabled,
       _debugLog = debugLog {
    _messagesController = StreamController<NotificationPayload>.broadcast(
      onListen: _startForwarding,
      onCancel: _stopForwarding,
    );
  }

  static bool _alwaysEnabled() => true;

  final PushProvider _pushProvider;
  final LocalScheduler _localScheduler;
  final NotificationRouter _router;
  final NotificationEnabledGate _enabled;
  final NotificationDebugLog _debugLog;

  late final StreamController<NotificationPayload> _messagesController;
  StreamSubscription<NotificationPayload>? _messagesSubscription;
  StreamSubscription<NotificationPayload>? _tapsSubscription;

  void _startForwarding() {
    _messagesSubscription = _pushProvider.messages.listen(
      _messagesController.add,
      onError: (Object error, StackTrace stackTrace) {
        _debugLog.reportProviderError(
          error,
          stackTrace,
          operation: 'message delivery',
        );
      },
    );
    _tapsSubscription = _pushProvider.taps.listen(_handleTap);
  }

  void _stopForwarding() {
    unawaited(_messagesSubscription?.cancel());
    unawaited(_tapsSubscription?.cancel());
  }

  /// Releases the internal broadcast controller and any active
  /// subscription. Call from the app's teardown/dispose path.
  Future<void> dispose() async {
    _stopForwarding();
    await _messagesController.close();
  }

  Future<void> _handleTap(NotificationPayload payload) async {
    if (!_enabled()) return;
    try {
      await _router(payload);
    } on Object catch (error, stackTrace) {
      _debugLog.reportRouterError(error, stackTrace);
    }
  }

  @override
  Future<String?> get token async {
    try {
      return await _pushProvider.token;
    } on Object catch (error, stackTrace) {
      _debugLog.reportProviderError(
        error,
        stackTrace,
        operation: 'token access',
      );
      return null;
    }
  }

  @override
  Stream<String> get tokenChanges => _pushProvider.tokenChanges;

  @override
  Stream<NotificationPayload> get messages => _messagesController.stream;

  @override
  Future<Result<String, NotificationFailure>> schedule({
    required NotificationPayload payload,
    required DateTime scheduledAt,
    String? channelId,
  }) async {
    if (!_enabled()) {
      return const Err(ScheduleFailure(message: 'notifications are disabled'));
    }
    try {
      final id = await _localScheduler.schedule(
        payload: payload,
        scheduledAt: scheduledAt,
        channelId: channelId,
      );
      return Success(id);
    } on Object catch (error, stackTrace) {
      _debugLog.reportProviderError(error, stackTrace, operation: 'schedule');
      return Err(
        ScheduleFailure(
          message: 'failed to schedule notification',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Result<Unit, NotificationFailure>> cancel(String id) async {
    try {
      await _localScheduler.cancel(id);
      return const Success(Unit.value);
    } on Object catch (error, stackTrace) {
      _debugLog.reportProviderError(error, stackTrace, operation: 'cancel');
      return Err(
        CancelFailure(message: 'failed to cancel notification', cause: error),
      );
    }
  }

  @override
  Future<Result<Unit, NotificationFailure>> cancelAll() async {
    try {
      await _localScheduler.cancelAll();
      return const Success(Unit.value);
    } on Object catch (error, stackTrace) {
      _debugLog.reportProviderError(error, stackTrace, operation: 'cancelAll');
      return Err(
        CancelFailure(
          message: 'failed to cancel all notifications',
          cause: error,
        ),
      );
    }
  }
}
