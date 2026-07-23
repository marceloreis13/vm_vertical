import 'package:flutter_test/flutter_test.dart';
import 'package:vm_config/vm_config.dart';

void main() {
  group('StaticMapConfigProvider', () {
    test('fetch returns the current in-memory map', () async {
      final provider = StaticMapConfigProvider(const {'flag': true});

      final result = await provider.fetch();

      expect(result.when(success: (value) => value, failure: (_) => null), {
        'flag': true,
      });
    });

    test('set mutates the map and is reflected on the next fetch', () async {
      final provider = StaticMapConfigProvider();

      provider.set('flag', true);
      final result = await provider.fetch();

      expect(result.when(success: (value) => value, failure: (_) => null), {
        'flag': true,
      });
    });

    test('remove drops a key from the next fetch', () async {
      final provider = StaticMapConfigProvider(const {'flag': true});

      provider.remove('flag');
      final result = await provider.fetch();

      expect(
        result.when(success: (value) => value, failure: (_) => null),
        <String, Object?>{},
      );
    });

    test('currentValues reflects mutations without a fetch', () {
      final provider = StaticMapConfigProvider();

      provider.set('flag', true);

      expect(provider.currentValues, {'flag': true});
    });
  });
}
