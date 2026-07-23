import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_storyboard/src/presentation/gallery/gallery_cubit.dart';
import 'package:vm_storyboard/src/presentation/gallery/sections/feedback_section.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

/// Demonstrates the Section testing pattern from `vm-ui-composition`: pump
/// with a real `GalleryCubit` (no fakes needed here, it has no IO) via
/// `BlocProvider`, exercise a state transition, assert composition.
void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildVmTheme(
      tokens: VmThemeTokens.standard(),
      palette: VmColorPalette.mock(),
    ).light,
    home: Scaffold(
      body: BlocProvider(create: (_) => GalleryCubit(), child: child),
    ),
  );

  testWidgets(
    'FeedbackSection hides the banner after GalleryCubit.dismissBanner',
    (tester) async {
      await tester.pumpWidget(wrap(const FeedbackSection()));

      expect(
        find.text('You are offline. Some content may be outdated.'),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(
        find.text('You are offline. Some content may be outdated.'),
        findsNothing,
      );
    },
  );
}
