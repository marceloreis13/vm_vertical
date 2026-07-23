import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

Future<void> _pumpCard(
  WidgetTester tester,
  Brightness brightness,
  VmAsyncActionCard card,
) async {
  final theme = buildVmTheme(
    tokens: VmThemeTokens.standard(),
    palette: VmColorPalette.mock(),
  );
  tester.view.physicalSize = const Size(420, 400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light ? theme.light : theme.dark,
      home: Scaffold(body: Center(child: card)),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final themeName = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('idle state matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        brightness,
        VmAsyncActionCard(
          title: 'Direct call',
          description: 'GET /get, no auth',
          status: VmAsyncStatus.idle,
          buttonLabel: 'Run',
          onPressed: () {},
        ),
      );
      await expectLater(
        find.byType(VmAsyncActionCard),
        matchesGoldenFile('vm_async_action_card_idle_$themeName.png'),
      );
    });

    testWidgets('loading state matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        brightness,
        VmAsyncActionCard(
          title: 'Direct call',
          status: VmAsyncStatus.loading,
          buttonLabel: 'Run',
          onPressed: () {},
        ),
      );
      await expectLater(
        find.byType(VmAsyncActionCard),
        matchesGoldenFile('vm_async_action_card_loading_$themeName.png'),
      );
    });

    testWidgets('success state matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        brightness,
        VmAsyncActionCard(
          title: 'Direct call',
          status: VmAsyncStatus.success,
          buttonLabel: 'Run',
          onPressed: () {},
          successContent: const Text('200 OK'),
        ),
      );
      await expectLater(
        find.byType(VmAsyncActionCard),
        matchesGoldenFile('vm_async_action_card_success_$themeName.png'),
      );
    });

    testWidgets('error state matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        brightness,
        VmAsyncActionCard(
          title: 'Direct call',
          status: VmAsyncStatus.error,
          buttonLabel: 'Run',
          onPressed: () {},
          errorMessage: 'Server responded 500',
        ),
      );
      await expectLater(
        find.byType(VmAsyncActionCard),
        matchesGoldenFile('vm_async_action_card_error_$themeName.png'),
      );
    });
  }
}
