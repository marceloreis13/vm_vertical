import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_localization/src/data/formatting/intl_formatters.dart';

void main() {
  const ptBr = Locale('pt', 'BR');
  const en = Locale('en');
  final date = DateTime(2026, 3, 5);

  group('IntlDateFormatter', () {
    test('formats the same date differently between pt_BR and en', () {
      const formatter = IntlDateFormatter();

      final ptFormatted = formatter.format(date, ptBr);
      final enFormatted = formatter.format(date, en);

      expect(ptFormatted, isNot(enFormatted));
    });
  });

  group('IntlNumberFormatter', () {
    test('formats the same number differently between pt_BR and en', () {
      const formatter = IntlNumberFormatter();

      final ptFormatted = formatter.format(1234.5, ptBr);
      final enFormatted = formatter.format(1234.5, en);

      expect(ptFormatted, isNot(enFormatted));
    });
  });

  group('IntlCurrencyFormatter', () {
    test(
      'formats the same value with a different currency symbol between pt_BR and en',
      () {
        const formatter = IntlCurrencyFormatter();

        final ptFormatted = formatter.format(19.9, ptBr);
        final enFormatted = formatter.format(19.9, en);

        expect(ptFormatted, isNot(enFormatted));
      },
    );
  });
}
