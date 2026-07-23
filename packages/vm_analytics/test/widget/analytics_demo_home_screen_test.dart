import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_analytics/src/presentation/demo/screen/analytics_demo_home_screen.dart';
import 'package:vm_analytics/vm_analytics.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

void main() {
  late GetIt getIt;
  late DebugAnalyticsProvider debugProvider;
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
    debugProvider = DebugAnalyticsProvider();
    registerVmAnalyticsModule(
      getIt,
      config: VmAnalyticsConfig(providers: [debugProvider]),
    );
  });

  tearDown(() async {
    await debugProvider.dispose();
    await getIt.reset();
  });

  Widget buildApp() => MaterialApp(
    theme: theme.light,
    home: AnalyticsDemoHomeScreen(debugProvider: debugProvider, getIt: getIt),
  );

  testWidgets('empty state renders before any call is made', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.textContaining('No analytics calls yet'), findsOneWidget);
  });

  testWidgets('dispatching an event renders it in the live call list', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Viewed product'));
    await tester.pump();

    expect(find.textContaining('viewed_product'), findsOneWidget);
  });

  testWidgets('setting the user id renders it in the live call list', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Set user id'));
    await tester.pump();

    expect(find.textContaining('setUserId'), findsOneWidget);
  });
}
