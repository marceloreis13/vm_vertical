import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_config/vm_config.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmConfigModule', () {
    test('resolves the ConfigReader abstraction', () {
      registerVmConfigModule(
        getIt,
        config: const VmConfigConfig(provider: LocalConfigProvider()),
      );

      expect(getIt<ConfigReader>(), isA<ConfigReader>());
    });

    test('the resolved ConfigReader exposes the configured environment', () {
      registerVmConfigModule(
        getIt,
        config: const VmConfigConfig(
          provider: LocalConfigProvider(),
          environment: VmEnvironment.prod,
        ),
      );

      expect(getIt<ConfigReader>().environment, VmEnvironment.prod);
    });

    test('defaults are resolvable through the registered reader', () {
      registerVmConfigModule(
        getIt,
        config: const VmConfigConfig(
          provider: LocalConfigProvider(),
          defaults: {'theme': 'light'},
        ),
      );

      expect(getIt<ConfigReader>().getString('theme', 'dark'), 'light');
    });

    test('registers and runs without any cache wired', () {
      registerVmConfigModule(
        getIt,
        config: const VmConfigConfig(provider: LocalConfigProvider()),
      );

      expect(getIt<ConfigReader>().getBool('flag', true), isTrue);
    });
  });
}
