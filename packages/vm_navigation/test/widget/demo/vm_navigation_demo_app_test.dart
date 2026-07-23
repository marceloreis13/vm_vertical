import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_navigation/vm_navigation.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    registerVmStoryboardModule(
      getIt,
      config: VmThemeConfig(
        palette: VmColorPalette.mock(),
        logo: VmLogo.mock(),
      ),
    );
    registerVmNavigationModule(getIt);
    getIt.registerSingleton(DemoSessionCubit());
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('protected route redirects to login while logged out', (
    tester,
  ) async {
    await tester.pumpWidget(const VmNavigationDemoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to protected route'));
    await tester.pumpAndSettle();

    expect(find.text('Redirected'), findsOneWidget);
  });

  testWidgets('toggling the session on lets the protected route resolve', (
    tester,
  ) async {
    await tester.pumpWidget(const VmNavigationDemoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logged in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to protected route'));
    await tester.pumpAndSettle();

    expect(find.text('Protected route'), findsOneWidget);
  });

  testWidgets('Cubit-driven navigation returns home with no BuildContext', (
    tester,
  ) async {
    await tester.pumpWidget(const VmNavigationDemoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to Cubit-driven navigation'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go Home via Cubit'));
    await tester.pumpAndSettle();

    expect(find.text('vm_navigation example'), findsOneWidget);
  });
}
