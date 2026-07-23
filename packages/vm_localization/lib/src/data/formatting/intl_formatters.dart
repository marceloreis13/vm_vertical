import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../domain/formatting.dart';

/// Locale tags whose `intl` date symbol data has already been loaded.
/// `initializeDateFormatting` completes synchronously outside the web
/// runtime (its data is compiled in, not fetched), so calling it once per
/// tag before the first format is enough to keep `format` itself
/// synchronous.
final Set<String> _initializedDateLocales = {};

void _ensureDateLocaleInitialized(String tag) {
  if (_initializedDateLocales.add(tag)) {
    initializeDateFormatting(tag);
  }
}

/// `intl`-backed `VmDateFormatter`: a medium date pattern resolved per
/// locale (e.g. day/month order differs between `pt_BR` and `en`).
class IntlDateFormatter implements VmDateFormatter {
  const IntlDateFormatter();

  @override
  String format(DateTime value, Locale locale) {
    final tag = locale.toLanguageTag();
    _ensureDateLocaleInitialized(tag);
    return DateFormat.yMMMd(tag).format(value);
  }
}

/// `intl`-backed `VmNumberFormatter`: locale-specific grouping/decimal
/// separators via `NumberFormat.decimalPattern`.
class IntlNumberFormatter implements VmNumberFormatter {
  const IntlNumberFormatter();

  @override
  String format(num value, Locale locale) {
    return NumberFormat.decimalPattern(locale.toLanguageTag()).format(value);
  }
}

/// `intl`-backed `VmCurrencyFormatter`: currency symbol/format inferred
/// from the locale via `NumberFormat.simpleCurrency`.
class IntlCurrencyFormatter implements VmCurrencyFormatter {
  const IntlCurrencyFormatter();

  @override
  String format(num value, Locale locale) {
    return NumberFormat.simpleCurrency(
      locale: locale.toLanguageTag(),
    ).format(value);
  }
}
