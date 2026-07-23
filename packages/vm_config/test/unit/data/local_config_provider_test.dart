import 'package:flutter_test/flutter_test.dart';
import 'package:vm_config/vm_config.dart';

void main() {
  group('LocalConfigProvider', () {
    test('fetch succeeds with an empty snapshot', () async {
      const provider = LocalConfigProvider();

      final result = await provider.fetch();

      expect(
        result.when(success: (value) => value, failure: (_) => null),
        <String, Object?>{},
      );
    });
  });
}
