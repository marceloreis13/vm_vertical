import 'dart:async';

import '../../domain/notification_channel.dart';
import '../../domain/notification_payload.dart';
import '../../domain/notification_provider.dart';

/// Built-in in-memory [NotificationProvider]: implements both the
/// `PushProvider` and `LocalScheduler` ports with no native plugin. Records
/// scheduled locals (and reflects cancellations) so tests/`example` can
/// assert on them, and exposes [simulateIncomingPush]/[simulateTap] hooks
/// that drive `NotificationService`'s streams.
class FakeNotificationProvider implements NotificationProvider {
  FakeNotificationProvider({String? initialToken}) : _token = initialToken;

  String? _token;
  final _tokenChangesController = StreamController<String>.broadcast();
  final _messagesController = StreamController<NotificationPayload>.broadcast();
  final _tapsController = StreamController<NotificationPayload>.broadcast();

  final Map<String, NotificationPayload> _scheduled = {};
  final List<NotificationChannel> _channels = [];
  int _nextId = 0;

  /// Optional exception a test can install to make [schedule] throw,
  /// exercising the facade's failure-mapping path.
  Object? scheduleException;

  /// Optional exception a test can install to make [cancel] throw.
  Object? cancelException;

  /// Read-only view of the currently scheduled locals, keyed by id.
  Map<String, NotificationPayload> get scheduled =>
      Map.unmodifiable(_scheduled);

  /// Read-only view of the channels registered so far.
  List<NotificationChannel> get channels => List.unmodifiable(_channels);

  /// Simulates the provider rotating the push token.
  void setToken(String? value) {
    _token = value;
    if (value != null) _tokenChangesController.add(value);
  }

  /// Simulates an incoming push notification (foreground or background).
  void simulateIncomingPush(NotificationPayload payload) {
    _messagesController.add(payload);
  }

  /// Simulates the user tapping a delivered notification.
  void simulateTap(NotificationPayload payload) {
    _tapsController.add(payload);
  }

  @override
  Future<String?> get token async => _token;

  @override
  Stream<String> get tokenChanges => _tokenChangesController.stream;

  @override
  Stream<NotificationPayload> get messages => _messagesController.stream;

  @override
  Stream<NotificationPayload> get taps => _tapsController.stream;

  @override
  Future<void> registerChannels(List<NotificationChannel> channels) async {
    _channels
      ..clear()
      ..addAll(channels);
  }

  @override
  Future<String> schedule({
    required NotificationPayload payload,
    required DateTime scheduledAt,
    String? channelId,
  }) async {
    final exception = scheduleException;
    if (exception != null) throw exception;
    final id = 'fake-notification-${_nextId++}';
    _scheduled[id] = payload;
    return id;
  }

  @override
  Future<void> cancel(String id) async {
    final exception = cancelException;
    if (exception != null) throw exception;
    _scheduled.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    final exception = cancelException;
    if (exception != null) throw exception;
    _scheduled.clear();
  }

  /// Releases stream controllers; call from test/example teardown.
  Future<void> dispose() async {
    await _tokenChangesController.close();
    await _messagesController.close();
    await _tapsController.close();
  }
}
