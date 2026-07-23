import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/network/network_log_adapter.dart';
import '../../data/sinks/console_log_sink.dart';
import '../../domain/log_entry.dart';
import '../../domain/logger.dart';

/// Drives the `vm_logging` visual example: emits log calls at every level
/// (plus one carrying sensitive data and one via [NetworkLogAdapter]) and
/// mirrors the entries the app-registered [ConsoleLogSink] observes, so the
/// screen can render exactly what was actually delivered — already
/// redacted, in order.
class LoggingDemoCubit extends Cubit<List<LogEntry>> {
  LoggingDemoCubit({required Logger logger, required ConsoleLogSink sink})
    : _logger = logger,
      _networkAdapter = NetworkLogAdapter(logger),
      super(const []) {
    _subscription = sink.entries.listen((entry) => emit([...state, entry]));
  }

  final Logger _logger;
  final NetworkLogAdapter _networkAdapter;
  StreamSubscription<LogEntry>? _subscription;

  void emitTrace() =>
      _logger.trace('Trace: verbose diagnostic detail', fields: {'demo': true});

  void emitDebug() =>
      _logger.debug('Debug: internal state snapshot', fields: {'step': 1});

  void emitInfo() =>
      _logger.info('Info: user completed onboarding', fields: {'userId': 42});

  void emitWarn() =>
      _logger.warn('Warn: retrying a slow dependency', fields: {'attempt': 2});

  void emitError() => _logger.error(
    'Error: failed to save profile',
    fields: {'userId': 42},
    error: StateError('save failed'),
    stackTrace: StackTrace.current,
  );

  void emitSensitive() => _logger.info(
    'Login attempt',
    fields: {
      'username': 'demo@vertical.dev',
      'password': 'hunter2',
      'authorization': 'Bearer secret-token-123',
    },
  );

  void emitNetworkRequest() => _networkAdapter.logExchange(
    method: 'POST',
    url: 'https://api.example.com/v1/login',
    statusCode: 401,
    headers: {'Authorization': 'Bearer secret-token-123', 'Accept': 'json'},
    duration: const Duration(milliseconds: 240),
  );

  @override
  Future<void> close() {
    unawaited(_subscription?.cancel());
    return super.close();
  }
}
