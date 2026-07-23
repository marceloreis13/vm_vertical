import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_notifications/vm_notifications.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Global navigator key the injected `NotificationRouter` uses to push the
/// target screen — demonstrating tap→route with no `vm_navigation`
/// dependency in `vm_notifications` itself. Easy to tweak (see
/// `docs/module-scaffold.md`): swap this for the app's own navigator.
final navigatorKey = GlobalKey<NavigatorState>();

/// Thin runnable shell: registers `vm_storyboard` (theme) and
/// `vm_notifications` (with the built-in fake provider and a router that
/// pushes `NotificationTargetScreen`) then runs `NotificationDemoScreen`,
/// which lives in `package:vm_notifications` itself so any app can embed it
/// the same way.
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  final fakeProvider = FakeNotificationProvider(initialToken: 'fake-token-1');

  registerVmNotificationsModule(
    getIt,
    config: VmNotificationsConfig(
      provider: fakeProvider,
      router: (payload) async {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NotificationTargetScreen(payload: payload),
          ),
        );
      },
      defaultChannels: const [
        NotificationChannel(id: 'default', name: 'Default'),
      ],
    ),
  );

  runApp(VmNotificationsExampleApp(fakeProvider: fakeProvider));
}

class VmNotificationsExampleApp extends StatelessWidget {
  const VmNotificationsExampleApp({required this.fakeProvider, super.key});

  final FakeNotificationProvider fakeProvider;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<VmTheme>();
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'vm_notifications example',
      theme: theme.light,
      darkTheme: theme.dark,
      home: NotificationDemoScreen(fakeProvider: fakeProvider),
    );
  }
}

/// The target screen the injected `NotificationRouter` navigates to on tap,
/// showing the payload that drove the navigation.
class NotificationTargetScreen extends StatelessWidget {
  const NotificationTargetScreen({required this.payload, super.key});

  final NotificationPayload payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VmAppBar(title: 'Target screen'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                payload.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(payload.body),
              const SizedBox(height: 8),
              Text('route: ${payload.data['route']}'),
            ],
          ),
        ),
      ),
    );
  }
}
