/// vm_logging: an injectable, level-based structured logging module.
/// Consumers depend on the `Logger` interface only — the consuming app
/// decides sinks, levels and redaction via `registerVmLogging`. No vendor
/// SDK type or `vm_*` dependency appears in the public API.
library;

export 'src/data/di/vm_logging_registration.dart';
export 'src/data/network/network_log_adapter.dart';
export 'src/data/redaction/redaction_pipeline.dart' show kRedactionPlaceholder;
export 'src/data/redaction/regex_redactor.dart';
export 'src/data/sinks/console_log_sink.dart';
export 'src/data/sinks/noop_log_sink.dart';
export 'src/domain/log_entry.dart';
export 'src/domain/log_level.dart';
export 'src/domain/log_sink.dart';
export 'src/domain/logger.dart';
export 'src/domain/redactor.dart';
export 'src/domain/vm_logging_config.dart';
export 'src/presentation/demo/screen/logging_demo_screen.dart';
