/// The single logging API consumers depend on. Every call is **synchronous
/// and returns `void`**: a [Logger] never blocks the caller and never throws
/// at the call site, regardless of sink behavior or failures. No vendor SDK
/// type appears in this interface.
abstract class Logger {
  void trace(String message, {Map<String, Object?> fields = const {}});

  void debug(String message, {Map<String, Object?> fields = const {}});

  void info(String message, {Map<String, Object?> fields = const {}});

  void warn(
    String message, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  });

  void error(
    String message, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  });

  /// Returns a child [Logger] that binds [fields] over this logger's
  /// context. Merge precedence at emit time is base context < bound child
  /// fields < per-call `fields`, most specific wins on key collision.
  Logger forContext(Map<String, Object?> fields);
}
