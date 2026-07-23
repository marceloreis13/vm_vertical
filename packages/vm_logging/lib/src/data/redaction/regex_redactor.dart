import '../../domain/redactor.dart';
import 'redaction_pipeline.dart';

/// A [Redactor] that masks every substring matching [pattern], anywhere it
/// appears in a field value or the message, independent of the field key
/// (e.g. emails, card numbers, bearer tokens).
class RegexRedactor implements Redactor {
  const RegexRedactor(this.pattern, {this.placeholder = kRedactionPlaceholder});

  final RegExp pattern;
  final String placeholder;

  @override
  String redactMessage(String message) =>
      message.replaceAll(pattern, placeholder);

  @override
  Object? redactValue(Object? value) {
    if (value is! String) return value;
    return value.replaceAll(pattern, placeholder);
  }
}
