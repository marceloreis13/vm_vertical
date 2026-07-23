// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/notification_kind.dart';
import '../../domain/notification_payload.dart';
import '../../domain/notification_service.dart';
import '../../data/fake/fake_notification_provider.dart';
import 'notification_demo_state.dart';

/// Drives the `vm_notifications` visual example: schedules a local
/// notification and simulates an incoming push through the injected
/// [FakeNotificationProvider], reading the unified stream back through the
/// app-registered [NotificationService] facade — demonstrating the public
/// API end to end with no native plugin.
class NotificationDemoCubit extends Cubit<NotificationDemoState> {
  NotificationDemoCubit({
    required NotificationService service,
    required FakeNotificationProvider fakeProvider,
  }) : _service = service,
       _fakeProvider = fakeProvider,
       super(NotificationDemoState.initial()) {
    _messagesSubscription = _service.messages.listen(_onMessage);
    unawaited(_loadToken());
  }

  final NotificationService _service;
  final FakeNotificationProvider _fakeProvider;
  late final StreamSubscription<NotificationPayload> _messagesSubscription;

  Future<void> _loadToken() async {
    final token = await _service.token;
    emit(state.copyWith(token: token));
  }

  void _onMessage(NotificationPayload payload) {
    emit(state.copyWith(receivedLog: [...state.receivedLog, payload]));
  }

  /// Schedules a local notification a few seconds in the future.
  Future<void> scheduleLocal() async {
    final result = await _service.schedule(
      payload: const NotificationPayload(
        title: 'Local reminder',
        body: 'Scheduled from the vm_notifications example',
        kind: NotificationKind.local,
        data: {'route': '/target'},
      ),
      scheduledAt: DateTime.now().add(const Duration(seconds: 5)),
    );
    result.when(
      success: (id) => emit(
        state.copyWith(
          scheduledIds: [...state.scheduledIds, id],
          lastFailure: null,
        ),
      ),
      failure: (failure) =>
          emit(state.copyWith(lastFailure: failure.toString())),
    );
  }

  /// Simulates an incoming push via the fake provider.
  void simulatePush() {
    _fakeProvider.simulateIncomingPush(
      const NotificationPayload(
        title: 'Simulated push',
        body: 'Tap to route to the target screen',
        kind: NotificationKind.push,
        data: {'route': '/target'},
      ),
    );
  }

  /// Simulates tapping the most recently received notification, driving the
  /// injected `NotificationRouter`.
  void tapLastReceived() {
    if (state.receivedLog.isEmpty) return;
    _fakeProvider.simulateTap(state.receivedLog.last);
  }

  @override
  Future<void> close() {
    unawaited(_messagesSubscription.cancel());
    return super.close();
  }
}
