import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_navigation/vm_navigation.dart';
import 'package:vm_tabbar/vm_tabbar.dart';

void main() {
  group('VmTabbarDemoApp', () {
    testWidgets('runs standalone with three tabs bound to mock branches', (
      tester,
    ) async {
      final getIt = GetIt.asNewInstance();
      registerVmNavigationModule(getIt);
      registerVmTabbarDemo(getIt);

      await tester.pumpWidget(VmTabbarDemoApp(getIt: getIt));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsWidgets); // AppBar title + tab label
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Home item 0'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await getIt.reset();
    });

    testWidgets('badge value increments live on the Profile tab', (
      tester,
    ) async {
      final getIt = GetIt.asNewInstance();
      registerVmNavigationModule(getIt);
      registerVmTabbarDemo(getIt);

      await tester.pumpWidget(VmTabbarDemoApp(getIt: getIt));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Unread notifications: 0'), findsOneWidget);

      final badgeSource = getIt<DemoBadgeSource>();
      badgeSource.notifier.value = const VmBadge.count(1);
      await tester.pump();

      expect(find.text('Unread notifications: 1'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await getIt.reset();
    });

    testWidgets('state preservation: scroll/push, switch tabs, return', (
      tester,
    ) async {
      final getIt = GetIt.asNewInstance();
      registerVmNavigationModule(getIt);
      registerVmTabbarDemo(getIt);

      await tester.pumpWidget(VmTabbarDemoApp(getIt: getIt));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Push a sub-route'));
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsOneWidget);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Search branch'), findsOneWidget);

      await tester.tap(find.text('Home').last);
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await getIt.reset();
    });
  });
}
