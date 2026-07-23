import 'package:flutter_test/flutter_test.dart';
import 'package:vm_config/src/data/resolution/config_resolution_engine.dart';
import 'package:vm_config/vm_config.dart';

import '../../fakes/fake_config_cache.dart';
import '../../fakes/fake_config_debug_log.dart';

void main() {
  group('ConfigResolutionEngine', () {
    test('resolves defaults synchronously with no cache', () {
      final engine = ConfigResolutionEngine(
        defaults: const {'theme': 'light'},
        debugLog: FakeConfigDebugLog(),
      );

      expect(engine.resolved, {'theme': 'light'});
    });

    test('resolves the cached snapshot over defaults at construction', () {
      final cache = FakeConfigCache(const {'theme': 'dark'});
      final engine = ConfigResolutionEngine(
        defaults: const {'theme': 'light', 'count': 1},
        cache: cache,
        debugLog: FakeConfigDebugLog(),
      );

      expect(engine.resolved, {'theme': 'dark', 'count': 1});
    });

    test('remote overrides cache and default for the same key', () async {
      final cache = FakeConfigCache(const {'theme': 'dark'});
      final engine = ConfigResolutionEngine(
        defaults: const {'theme': 'light'},
        cache: cache,
        debugLog: FakeConfigDebugLog(),
      );

      await engine.applyRemoteSnapshot(const {'theme': 'system'});

      expect(engine.resolved['theme'], 'system');
    });

    test('cache is used when remote lacks the key', () async {
      final cache = FakeConfigCache(const {'theme': 'dark'});
      final engine = ConfigResolutionEngine(
        defaults: const {'theme': 'light'},
        cache: cache,
        debugLog: FakeConfigDebugLog(),
      );

      await engine.applyRemoteSnapshot(const {});

      expect(engine.resolved['theme'], 'dark');
    });

    test('default is used when neither remote nor cache has the key', () {
      final engine = ConfigResolutionEngine(
        defaults: const {'theme': 'light'},
        debugLog: FakeConfigDebugLog(),
      );

      expect(engine.resolved['theme'], 'light');
      expect(engine.resolved.containsKey('missing'), isFalse);
    });

    test('emits only the keys whose resolved value changed', () async {
      final engine = ConfigResolutionEngine(
        defaults: const {'a': 1, 'b': 2},
        debugLog: FakeConfigDebugLog(),
      );

      final changeEvents = <ConfigChange>[];
      engine.changes.listen(changeEvents.add);

      await engine.applyRemoteSnapshot(const {'a': 10, 'b': 2});
      await pumpEventQueue();

      expect(changeEvents, hasLength(1));
      expect(changeEvents.single.keys, {'a'});
    });

    test('a recompute with no actual change emits nothing', () async {
      final engine = ConfigResolutionEngine(
        defaults: const {'a': 1},
        debugLog: FakeConfigDebugLog(),
      );

      final changeEvents = <ConfigChange>[];
      engine.changes.listen(changeEvents.add);

      await engine.applyRemoteSnapshot(const {'a': 1});
      await pumpEventQueue();

      expect(changeEvents, isEmpty);
    });

    test('persists a successful remote snapshot to the cache', () async {
      final cache = FakeConfigCache();
      final engine = ConfigResolutionEngine(
        defaults: const {},
        cache: cache,
        debugLog: FakeConfigDebugLog(),
      );

      await engine.applyRemoteSnapshot(const {'flag': true});

      expect(cache.writes.single, {'flag': true});
    });

    test('isolates a cache read failure and falls back to defaults', () {
      final cache = FakeConfigCache()..throwOnRead = true;
      final debugLog = FakeConfigDebugLog();
      final engine = ConfigResolutionEngine(
        defaults: const {'theme': 'light'},
        cache: cache,
        debugLog: debugLog,
      );

      expect(engine.resolved, {'theme': 'light'});
      expect(debugLog.reportedCacheOperations, ['read']);
    });

    test(
      'isolates a cache write failure without failing the refresh',
      () async {
        final cache = FakeConfigCache()..throwOnWrite = true;
        final debugLog = FakeConfigDebugLog();
        final engine = ConfigResolutionEngine(
          defaults: const {},
          cache: cache,
          debugLog: debugLog,
        );

        await engine.applyRemoteSnapshot(const {'flag': true});

        expect(engine.resolved, {'flag': true});
        expect(debugLog.reportedCacheOperations, ['write']);
      },
    );
  });
}
