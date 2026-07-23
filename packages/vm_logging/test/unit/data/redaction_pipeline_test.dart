import 'package:flutter_test/flutter_test.dart';
import 'package:vm_logging/vm_logging.dart';
import 'package:vm_logging/src/data/redaction/redaction_pipeline.dart';

import '../../fakes/fake_redactor.dart';

LogEntry _entry({
  String message = 'hello',
  Map<String, Object?> fields = const {},
}) => LogEntry(
  level: LogLevel.info,
  message: message,
  fields: fields,
  timestamp: DateTime(2026),
);

void main() {
  group('key-based redaction', () {
    test('masks a field whose key matches a sensitive key', () {
      final pipeline = const RedactionPipeline(
        sensitiveKeys: {'password'},
        redactors: [],
      );

      final redacted = pipeline.apply(_entry(fields: {'password': 'hunter2'}));

      expect(redacted.fields['password'], kRedactionPlaceholder);
      expect(redacted.fields['password'], isNot('hunter2'));
    });

    test('matches sensitive keys case-insensitively', () {
      final pipeline = const RedactionPipeline(
        sensitiveKeys: {'Password'},
        redactors: [],
      );

      final redacted = pipeline.apply(_entry(fields: {'PASSWORD': 'hunter2'}));

      expect(redacted.fields['PASSWORD'], kRedactionPlaceholder);
    });

    test('preserves non-sensitive fields alongside a masked one', () {
      final pipeline = const RedactionPipeline(
        sensitiveKeys: {'password'},
        redactors: [],
      );

      final redacted = pipeline.apply(
        _entry(fields: {'password': 'hunter2', 'username': 'demo'}),
      );

      expect(redacted.fields['password'], kRedactionPlaceholder);
      expect(redacted.fields['username'], 'demo');
    });
  });

  group('pluggable redactors', () {
    test('a registered redactor masks a matched pattern in the message', () {
      final pipeline = RedactionPipeline(
        sensitiveKeys: const {},
        redactors: [const FakeRedactor('secret')],
      );

      final redacted = pipeline.apply(_entry(message: 'contains secret data'));

      expect(redacted.message, 'contains <redacted> data');
    });

    test('a redactor masks a value under a non-sensitive key', () {
      final pipeline = RedactionPipeline(
        sensitiveKeys: const {},
        redactors: [const FakeRedactor('4111-1111')],
      );

      final redacted = pipeline.apply(
        _entry(fields: {'note': 'card 4111-1111 used'}),
      );

      expect(redacted.fields['note'], 'card <redacted> used');
    });

    test('redactors never re-process a value already masked by key', () {
      final pipeline = RedactionPipeline(
        sensitiveKeys: const {'password'},
        redactors: [const FakeRedactor(kRedactionPlaceholder)],
      );

      final redacted = pipeline.apply(_entry(fields: {'password': 'hunter2'}));

      // Key-based redaction wins outright; the field is not handed to
      // redactors afterward.
      expect(redacted.fields['password'], kRedactionPlaceholder);
    });
  });

  group('RegexRedactor', () {
    test('masks an email address anywhere in the message', () {
      final redactor = RegexRedactor(RegExp(r'[\w.+-]+@[\w-]+\.[\w.-]+'));

      expect(
        redactor.redactMessage('contact demo@vertical.dev now'),
        'contact $kRedactionPlaceholder now',
      );
    });

    test('leaves non-string values unchanged', () {
      final redactor = RegexRedactor(RegExp('x'));

      expect(redactor.redactValue(42), 42);
    });
  });
}
