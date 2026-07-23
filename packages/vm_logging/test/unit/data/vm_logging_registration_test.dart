import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_logging/vm_logging.dart';

import '../../fakes/fake_log_sink.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmLogging', () {
    test('resolves the Logger abstraction, not a concrete sink', () {
      registerVmLogging(getIt, config: const VmLoggingConfig());

      expect(getIt<Logger>(), isA<Logger>());
    });

    test('config sinks and levels drive routing on the resolved Logger', () {
      final debugSink = FakeLogSink();
      final errorSink = FakeLogSink();

      registerVmLogging(
        getIt,
        config: VmLoggingConfig(
          sinks: [
            SinkRegistration(sink: debugSink, minLevel: LogLevel.debug),
            SinkRegistration(sink: errorSink, minLevel: LogLevel.error),
          ],
        ),
      );

      final logger = getIt<Logger>();
      logger.debug('debug entry');
      logger.error('error entry');

      expect(debugSink.received, hasLength(2));
      expect(errorSink.received, hasLength(1));
    });

    test('with zero sinks configured, logging is a safe no-op', () {
      registerVmLogging(getIt, config: const VmLoggingConfig());

      expect(() => getIt<Logger>().info('noop'), returnsNormally);
    });
  });
}
