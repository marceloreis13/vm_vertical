import 'package:flutter_test/flutter_test.dart';
import 'package:vm_config/vm_config.dart';

void main() {
  group('InMemoryConfigCache', () {
    test('read returns null with no initial snapshot', () {
      final cache = InMemoryConfigCache();

      expect(cache.read(), isNull);
    });

    test('read returns the seeded initial snapshot', () {
      final cache = InMemoryConfigCache(const {'flag': true});

      expect(cache.read(), {'flag': true});
    });

    test('write replaces the snapshot returned by read', () async {
      final cache = InMemoryConfigCache();

      await cache.write(const {'flag': false});

      expect(cache.read(), {'flag': false});
    });
  });
}
