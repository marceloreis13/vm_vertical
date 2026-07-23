import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_config/vm_config.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

void main() {
  late GetIt getIt;
  late StaticMapConfigProvider provider;
  late VmTheme theme;

  const defaults = <String, Object?>{
    'new_checkout': false,
    'max_items': 5,
    'theme': 'light',
  };

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
    provider = StaticMapConfigProvider(const {'new_checkout': false});
    registerVmConfigModule(
      getIt,
      config: VmConfigConfig(provider: provider, defaults: defaults),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildApp() => MaterialApp(
    theme: theme.light,
    home: ConfigDemoScreen(
      provider: provider,
      defaultValues: defaults,
      getIt: getIt,
    ),
  );

  testWidgets('renders every demoed field with its resolved value', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('New checkout flow'), findsOneWidget);
    expect(find.text('Max items per page'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
  });

  testWidgets('toggling the switch updates the resolved value live', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('resolved: false'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('resolved: true'), findsOneWidget);
  });

  testWidgets('clearing the remote value falls back to the default', (
    tester,
  ) async {
    provider.set('new_checkout', true);
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('resolved: true'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.backspace_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('resolved: false'), findsOneWidget);
  });
}
