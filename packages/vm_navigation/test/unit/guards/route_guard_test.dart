import 'package:flutter_test/flutter_test.dart';
import 'package:vm_navigation/vm_navigation.dart';

class _SyncGuard extends RouteGuard {
  const _SyncGuard(this._allowed);

  final bool _allowed;

  @override
  bool evaluate() => _allowed;
}

class _AsyncGuard extends RouteGuard {
  const _AsyncGuard(this._allowed);

  final bool _allowed;

  @override
  Future<bool> evaluate() async => _allowed;
}

Future<bool> _combine(List<RouteGuard> guards) async {
  for (final guard in guards) {
    if (!await guard.evaluate()) return false;
  }
  return true;
}

void main() {
  group('RouteGuard', () {
    test('a single sync guard resolves true on pass', () {
      expect(const _SyncGuard(true).evaluate(), true);
    });

    test('a single sync guard resolves false on fail', () {
      expect(const _SyncGuard(false).evaluate(), false);
    });

    test('a single async guard resolves after awaiting', () async {
      expect(await const _AsyncGuard(true).evaluate(), true);
      expect(await const _AsyncGuard(false).evaluate(), false);
    });

    test('multiple guards combine as AND: all pass', () async {
      final result = await _combine(const [
        _SyncGuard(true),
        _AsyncGuard(true),
      ]);
      expect(result, true);
    });

    test('multiple guards combine as AND: one fails', () async {
      final result = await _combine(const [
        _SyncGuard(true),
        _AsyncGuard(false),
      ]);
      expect(result, false);
    });
  });
}
