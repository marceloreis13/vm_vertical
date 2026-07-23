import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Sealed taxonomy of storage-level failures. Every failure path of every
/// store resolves to one of these variants — never a raw exception.
@freezed
sealed class StorageFailure with _$StorageFailure {
  /// The targeted key/record does not exist, or has expired (TTL) or been
  /// soft-deleted.
  const factory StorageFailure.notFound({
    required String message,
    Object? cause,
  }) = StorageNotFoundFailure;

  /// The injected codec failed to encode or decode a value.
  const factory StorageFailure.serialization({
    required String message,
    Object? cause,
  }) = StorageSerializationFailure;

  /// The underlying backend threw while performing the operation.
  const factory StorageFailure.backend({
    required String message,
    Object? cause,
  }) = StorageBackendFailure;

  /// A secure-storage-specific error (e.g. keychain/keystore access denied).
  const factory StorageFailure.security({
    required String message,
    Object? cause,
  }) = StorageSecurityFailure;

  /// The registered backend does not support the requested operation.
  const factory StorageFailure.capabilityUnsupported({
    required String message,
    Object? cause,
  }) = StorageCapabilityUnsupportedFailure;
}
