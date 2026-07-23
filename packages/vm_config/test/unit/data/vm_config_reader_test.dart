import 'package:flutter_test/flutter_test.dart';
import 'package:vm_config/src/data/resolution/config_resolution_engine.dart';
import 'package:vm_config/src/data/vm_config_reader.dart';
import 'package:vm_config/vm_config.dart';

import '../../fakes/fake_config_debug_log.dart';
import '../../fakes/fake_remote_config_provider.dart';

VmConfigReaderImpl _buildReader({
  required FakeRemoteConfigProvider provider,
  required FakeConfigDebugLog debugLog,
  ConfigMap defaults = const {},
  Object? envObject,
}) {
  final engine = ConfigResolutionEngine(defaults: defaults, debugLog: debugLog);
  return VmConfigReaderImpl(
    provider: provider,
    engine: engine,
    environment: VmEnvironment.staging,
    debugLog: debugLog,
    envObject: envObject,
  );
}

void main() {
  group('VmConfigReaderImpl', () {
    test('getBool/getInt/getDouble/getString/getJson resolve known keys', () {
      final provider = FakeRemoteConfigProvider();
      final reader = _buildReader(
        provider: provider,
        debugLog: FakeConfigDebugLog(),
        defaults: const {
          'flag': true,
          'count': 5,
          'ratio': 1.5,
          'name': 'vm_core',
          'layout': {'columns': 2},
        },
      );

      expect(reader.getBool('flag', false), isTrue);
      expect(reader.getInt('count', 0), 5);
      expect(reader.getDouble('ratio', 0.0), 1.5);
      expect(reader.getString('name', ''), 'vm_core');
      expect(reader.getJson('layout', const {}), {'columns': 2});
    });

    test('unknown key returns the inline default', () {
      final reader = _buildReader(
        provider: FakeRemoteConfigProvider(),
        debugLog: FakeConfigDebugLog(),
      );

      expect(reader.getString('theme', 'light'), 'light');
    });

    test('a type mismatch falls back to the default and never throws', () {
      final debugLog = FakeConfigDebugLog();
      final reader = _buildReader(
        provider: FakeRemoteConfigProvider(),
        debugLog: debugLog,
        defaults: const {'count': 'not-an-int'},
      );

      late final int value;
      expect(() => value = reader.getInt('count', 10), returnsNormally);
      expect(value, 10);
      expect(debugLog.reportedTypeMismatchKeys, ['count']);
    });

    test('environment exposes the configured VmEnvironment', () {
      final reader = _buildReader(
        provider: FakeRemoteConfigProvider(),
        debugLog: FakeConfigDebugLog(),
      );

      expect(reader.environment, VmEnvironment.staging);
    });

    test('env<T>() returns the app-injected object unchanged', () {
      final reader = _buildReader(
        provider: FakeRemoteConfigProvider(),
        debugLog: FakeConfigDebugLog(),
        envObject: const _FakeAppEnv('https://api.test'),
      );

      expect(reader.env<_FakeAppEnv>().baseUrl, 'https://api.test');
    });

    test('refresh applies a successful fetch and reads reflect it', () async {
      final provider = FakeRemoteConfigProvider()
        ..nextSnapshot = const {'flag': true};
      final reader = _buildReader(
        provider: provider,
        debugLog: FakeConfigDebugLog(),
        defaults: const {'flag': false},
      );

      final result = await reader.refresh();

      expect(result.isSuccess, isTrue);
      expect(reader.getBool('flag', false), isTrue);
    });

    test(
      'refresh reports a provider failure and reads keep prior values',
      () async {
        final debugLog = FakeConfigDebugLog();
        final failure = const RemoteFetchFailure(message: 'network down');
        final provider = FakeRemoteConfigProvider()..nextFailure = failure;
        final reader = _buildReader(
          provider: provider,
          debugLog: debugLog,
          defaults: const {'flag': false},
        );

        final result = await reader.refresh();

        expect(result.isFailure, isTrue);
        expect(reader.getBool('flag', true), isFalse);
        expect(debugLog.reportedFetchFailures, [failure]);
      },
    );

    test(
      'a throwing provider is isolated and reported, reads keep serving',
      () async {
        final debugLog = FakeConfigDebugLog();
        final provider = FakeRemoteConfigProvider()
          ..throwOnFetch = StateError('boom');
        final reader = _buildReader(
          provider: provider,
          debugLog: debugLog,
          defaults: const {'flag': false},
        );

        final result = await reader.refresh();

        expect(result.isFailure, isTrue);
        expect(reader.getBool('flag', true), isFalse);
        expect(debugLog.reportedFetchFailures, hasLength(1));
      },
    );

    test(
      'valueStream emits the current value then re-emits on change',
      () async {
        final provider = FakeRemoteConfigProvider();
        final reader = _buildReader(
          provider: provider,
          debugLog: FakeConfigDebugLog(),
          defaults: const {'flag': false},
        );

        final emissions = <bool>[];
        final subscription = reader
            .valueStream('flag', false)
            .listen(emissions.add);
        await pumpEventQueue();

        provider.nextSnapshot = const {'flag': true};
        await reader.refresh();
        await pumpEventQueue();

        expect(emissions, [false, true]);
        await subscription.cancel();
      },
    );
  });
}

class _FakeAppEnv {
  const _FakeAppEnv(this.baseUrl);

  final String baseUrl;
}
