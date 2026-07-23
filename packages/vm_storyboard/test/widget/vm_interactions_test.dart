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
  testWidgets('VmChip toggles selection on tap', (tester) async {
    var selected = false;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => VmChip(
            label: 'Featured',
            selected: selected,
            onSelected: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );

    expect(selected, isFalse);
    await tester.tap(find.byType(FilterChip));
    await tester.pump();
    expect(selected, isTrue);
  });

  testWidgets('VmSegmentedControl selects the tapped segment', (tester) async {
    var value = 'C';
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => VmSegmentedControl<String>(
            segments: const [
              VmSegment(value: 'C', label: '°C'),
              VmSegment(value: 'F', label: '°F'),
            ],
            selected: value,
            onChanged: (newValue) => setState(() => value = newValue),
          ),
        ),
      ),
    );

    await tester.tap(find.text('°F'));
    await tester.pump();
    expect(value, 'F');
  });

  testWidgets('showVmSnackbar shows the message and schedules auto-dismiss', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => VmButton(
            label: 'Show',
            onPressed: () => showVmSnackbar(
              context,
              'Saved',
              duration: const Duration(seconds: 1),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);

    // Flutter's SnackBar itself owns the auto-dismiss timer; this asserts
    // we hand the configured duration through to it.
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.duration, const Duration(seconds: 1));
  });

  testWidgets('VmBanner calls onDismiss when the close action is tapped', (
    tester,
  ) async {
    var dismissed = false;
    await tester.pumpWidget(
      _wrap(
        VmBanner(
          message: 'You are offline.',
          onDismiss: () => dismissed = true,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(dismissed, isTrue);
  });
}
