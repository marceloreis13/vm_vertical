// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import '../../domain/log_entry.dart';
import '../../domain/redactor.dart';

/// Placeholder a value/message substring is replaced with once redacted.
const String kRedactionPlaceholder = '***';

/// Redaction pipeline stage: runs on a [LogEntry] before it reaches any
/// sink (see `logging-redaction`). Two mechanisms compose, in order:
///
/// 1. Key-based — any `fields` entry whose key matches [sensitiveKeys]
///    (case-insensitive) has its value replaced wholesale by
///    [kRedactionPlaceholder]. Non-sensitive fields are preserved. Applied
///    recursively into nested `Map<String, dynamic>` values (e.g. a
///    network adapter's `headers` field), so a sensitive key is masked
///    regardless of nesting depth.
/// 2. Pluggable [redactors] — ordered transforms applied over every
///    remaining field value and the message, for patterns not tied to a
///    specific key (emails, card numbers, bearer tokens, ...).
class RedactionPipeline {
  const RedactionPipeline({
    required Set<String> sensitiveKeys,
    required List<Redactor> redactors,
  }) : _sensitiveKeys = sensitiveKeys,
       _redactors = redactors;

  final Set<String> _sensitiveKeys;
  final List<Redactor> _redactors;

  LogEntry apply(LogEntry entry) {
    final redactedFields = <String, Object?>{
      for (final MapEntry(:key, :value) in entry.fields.entries)
        key: _redactField(key, value),
    };
    return entry.copyWith(
      message: _redactMessage(entry.message),
      fields: redactedFields,
    );
  }

  bool _isSensitiveKey(String key) => _sensitiveKeys.any(
    (sensitiveKey) => sensitiveKey.toLowerCase() == key.toLowerCase(),
  );

  Object? _redactField(String key, Object? value) {
    if (_isSensitiveKey(key)) return kRedactionPlaceholder;
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key: _redactField(entry.key as String, entry.value),
      };
    }
    return _redactValue(value);
  }

  String _redactMessage(String message) {
    var redacted = message;
    for (final redactor in _redactors) {
      redacted = redactor.redactMessage(redacted);
    }
    return redacted;
  }

  Object? _redactValue(Object? value) {
    var redacted = value;
    for (final redactor in _redactors) {
      redacted = redactor.redactValue(redacted);
    }
    return redacted;
  }
}
