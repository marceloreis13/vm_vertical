import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vm_locale_state.freezed.dart';

/// The active locale plus the configured list of supported locales.
@freezed
class VmLocaleState with _$VmLocaleState {
  const factory VmLocaleState({
    required Locale locale,
    required List<Locale> supportedLocales,
  }) = _VmLocaleState;
}
