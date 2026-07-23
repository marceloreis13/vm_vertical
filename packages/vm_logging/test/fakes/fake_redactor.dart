import 'package:vm_logging/vm_logging.dart';

/// A [Redactor] that masks a fixed literal substring wherever it appears,
/// in both the message and field values.
class FakeRedactor implements Redactor {
  const FakeRedactor(this.needle, {this.placeholder = '<redacted>'});

  final String needle;
  final String placeholder;

  @override
  String redactMessage(String message) =>
      message.replaceAll(needle, placeholder);

  @override
  Object? redactValue(Object? value) {
    if (value is! String) return value;
    return value.replaceAll(needle, placeholder);
  }
}
