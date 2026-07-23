import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_analytics/vm_analytics.dart';

import '../fakes/fake_analytics_tracker.dart';

void main() {
  Widget buildApp({
    required NavigatorObserver observer,
    Map<String, WidgetBuilder> routes = const {},
  }) => MaterialApp(
    navigatorObservers: [observer],
    initialRoute: '/home',
    routes: {
      '/home': (_) => const Scaffold(body: Text('Home')),
      '/details': (_) => const Scaffold(body: Text('Details')),
      ...routes,
    },
  );

  testWidgets('route change emits a screen view for the destination screen', (
    tester,
  ) async {
    final tracker = FakeAnalyticsTracker();
    final observer = AnalyticsRouteObserver(
      tracker: tracker,
      config: const VmAnalyticsConfig(),
    );

    await tester.pumpWidget(buildApp(observer: observer));
    await tester.pump();

    expect(
      tracker.received,
      contains(isA<ScreenViewCall>().having((c) => c.name, 'name', 'home')),
    );

    tracker.received.clear();
    final context = tester.element(find.text('Home'));
    unawaited(Navigator.of(context).pushNamed('/details'));
    await tester.pumpAndSettle();

    expect(
      tracker.received.single,
      isA<ScreenViewCall>().having((c) => c.name, 'name', 'details'),
    );
  });

  testWidgets('automatic tracking disabled suppresses screen views', (
    tester,
  ) async {
    final tracker = FakeAnalyticsTracker();
    final observer = AnalyticsRouteObserver(
      tracker: tracker,
      config: const VmAnalyticsConfig(automaticScreenTracking: false),
    );

    await tester.pumpWidget(buildApp(observer: observer));
    await tester.pump();

    final context = tester.element(find.text('Home'));
    unawaited(Navigator.of(context).pushNamed('/details'));
    await tester.pumpAndSettle();

    expect(tracker.received, isEmpty);
  });
}
