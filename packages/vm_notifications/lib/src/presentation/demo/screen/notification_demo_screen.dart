import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../data/fake/fake_notification_provider.dart';
import '../../../domain/notification_service.dart';
import '../notification_demo_cubit.dart';
import '../sections/notification_actions_section.dart';
import '../sections/notification_log_section.dart';

/// Entry point of the `vm_notifications` visual example. Resolves the
/// app-registered [NotificationService] (via `registerVmNotificationsModule`)
/// and takes the same [fakeProvider] instance the app registered so the demo
/// can simulate pushes/taps directly. Lives in `lib/`, not `example/`, so
/// any app can embed it directly (see `docs/module-scaffold.md`).
class NotificationDemoScreen extends StatelessWidget {
  const NotificationDemoScreen({
    required this.fakeProvider,
    this.getIt,
    super.key,
  });

  final FakeNotificationProvider fakeProvider;

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final service = container<NotificationService>();

    return BlocProvider(
      create: (_) =>
          NotificationDemoCubit(service: service, fakeProvider: fakeProvider),
      child: Scaffold(
        appBar: const VmAppBar(title: 'vm_notifications example'),
        body: const Column(
          children: [
            NotificationActionsSection(),
            Expanded(child: NotificationLogSection()),
          ],
        ),
      ),
    );
  }
}
