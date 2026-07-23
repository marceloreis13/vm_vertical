import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

VmTheme _theme() => buildVmTheme(
  tokens: VmThemeTokens.standard(),
  palette: VmColorPalette.mock(),
);

Widget _wrap(Widget child) => MaterialApp(
  theme: _theme().light,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('VmLoadingView shows a spinner and message', (tester) async {
    await tester.pumpWidget(_wrap(const VmLoadingView(message: 'Loading...')));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
  });

  testWidgets('VmEmptyView shows message and triggers its action', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        VmEmptyView(
          message: 'No results yet',
          actionLabel: 'Retry',
          onAction: () => tapped = true,
        ),
      ),
    );

    expect(find.text('No results yet'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('VmErrorView shows message and triggers retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      _wrap(
        VmErrorView(
          message: 'Something went wrong',
          onRetry: () => retried = true,
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(retried, isTrue);
  });
}
