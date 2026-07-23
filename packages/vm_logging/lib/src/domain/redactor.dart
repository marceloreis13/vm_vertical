/// A pluggable, ordered transform applied to a [LogEntry]'s message and
/// field values before any sink sees it (see `logging-redaction`). Typically
/// regex-based (emails, card numbers, bearer tokens) — patterns not tied to
/// a specific field key, unlike sensitive-key redaction.
abstract class Redactor {
  /// Returns [message] with any matched substring masked.
  String redactMessage(String message);

  /// Returns [value] with any matched substring masked. Non-`String` values
  /// are returned unchanged — a redactor only rewrites text.
  Object? redactValue(Object? value);
}
