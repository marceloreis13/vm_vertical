import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Sealed taxonomy of localization-level failures. Every failure path
/// resolves to one of these variants — never a raw exception.
@freezed
sealed class LocalizationFailure with _$LocalizationFailure {
  /// The persistence backend (e.g. `vm_storage`'s `KeyValueStore`) threw
  /// while reading or writing the saved locale.
  const factory LocalizationFailure.persistenceBackend({
    required String message,
    Object? cause,
  }) = LocalizationPersistenceBackendFailure;

  /// A locale outside the configured supported-locales list was requested.
  const factory LocalizationFailure.unsupportedLocale({
    required String message,
    Object? cause,
  }) = LocalizationUnsupportedLocaleFailure;
}
