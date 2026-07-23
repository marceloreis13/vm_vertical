import 'package:flutter/widgets.dart';

/// Formats a `DateTime` according to an explicitly given [Locale] — no
/// ambient/global locale state.
abstract class VmDateFormatter {
  String format(DateTime value, Locale locale);
}

/// Formats a numeric value according to an explicitly given [Locale]'s
/// grouping and decimal separator conventions.
abstract class VmNumberFormatter {
  String format(num value, Locale locale);
}

/// Formats a numeric value as currency, inferring the currency symbol/code
/// from the explicitly given [Locale].
abstract class VmCurrencyFormatter {
  String format(num value, Locale locale);
}
