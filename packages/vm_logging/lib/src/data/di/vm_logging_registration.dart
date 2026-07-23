import 'package:get_it/get_it.dart';

import '../../domain/logger.dart';
import '../../domain/vm_logging_config.dart';
import '../redaction/redaction_pipeline.dart';
import '../vm_logger.dart';

/// Single registration entry point for `vm_logging`. Receives its [config]
/// from the consuming app — no sink, level, sensitive key or redactor is
/// hard-coded inside the module. Consumers resolve only [Logger] from
/// [getIt]; the concrete sinks stay unknown to them.
void registerVmLogging(GetIt getIt, {required VmLoggingConfig config}) {
  getIt.registerSingleton<VmLoggingConfig>(config);
  getIt.registerSingleton<Logger>(
    VmLogger(
      sinks: config.sinks,
      redaction: RedactionPipeline(
        sensitiveKeys: config.sensitiveKeys,
        redactors: config.redactors,
      ),
    ),
  );
}
