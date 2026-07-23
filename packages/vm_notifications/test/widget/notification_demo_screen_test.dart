import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_notifications/vm_notifications.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

void main() {
  late GetIt getIt;
  late FakeNotificationProvider provider;
  late VmTheme theme;

  setUp(() {
    getIt = GetIt.asNewInstance();
    registerVmStoryboardModule(
      getIt,
      config: VmThemeConfig(
        palette: VmColorPalette.mock(),
        logo: VmLogo.mock(),
      ),
    );
    theme = getIt<VmTheme>();
    provider = FakeNotificationProvider(initialToken: 'demo-token');
    registerVmNotificationsModule(
      getIt,
      config: VmNotificationsConfig(provider: provider, router: (_) async {}),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildApp() => MaterialApp(
    theme: theme.light,
    home: NotificationDemoScreen(fakeProvider: provider, getIt: getIt),
  );

  testWidgets('renders the resolved push token and the actions', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('demo-token'), findsOneWidget);
    expect(find.text('Schedule local'), findsOneWidget);
    expect(find.text('Simulate push'), findsOneWidget);
  });

  testWidgets('simulating a push adds it to the received log', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simulate push'));
    await tester.pumpAndSettle();

    expect(find.text('Simulated push'), findsOneWidget);
  });
}
