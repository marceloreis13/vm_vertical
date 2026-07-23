// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LocalizationFailure {
  String get message => throw _privateConstructorUsedError;
  Object? get cause => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) persistenceBackend,
    required TResult Function(String message, Object? cause) unsupportedLocale,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? persistenceBackend,
    TResult? Function(String message, Object? cause)? unsupportedLocale,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? persistenceBackend,
    TResult Function(String message, Object? cause)? unsupportedLocale,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalizationPersistenceBackendFailure value)
    persistenceBackend,
    required TResult Function(LocalizationUnsupportedLocaleFailure value)
    unsupportedLocale,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalizationPersistenceBackendFailure value)?
    persistenceBackend,
    TResult? Function(LocalizationUnsupportedLocaleFailure value)?
    unsupportedLocale,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalizationPersistenceBackendFailure value)?
    persistenceBackend,
    TResult Function(LocalizationUnsupportedLocaleFailure value)?
    unsupportedLocale,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalizationFailureCopyWith<LocalizationFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalizationFailureCopyWith<$Res> {
  factory $LocalizationFailureCopyWith(
    LocalizationFailure value,
    $Res Function(LocalizationFailure) then,
  ) = _$LocalizationFailureCopyWithImpl<$Res, LocalizationFailure>;
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class _$LocalizationFailureCopyWithImpl<$Res, $Val extends LocalizationFailure>
    implements $LocalizationFailureCopyWith<$Res> {
  _$LocalizationFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            cause: freezed == cause ? _value.cause : cause,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocalizationPersistenceBackendFailureImplCopyWith<$Res>
    implements $LocalizationFailureCopyWith<$Res> {
  factory _$$LocalizationPersistenceBackendFailureImplCopyWith(
    _$LocalizationPersistenceBackendFailureImpl value,
    $Res Function(_$LocalizationPersistenceBackendFailureImpl) then,
  ) = __$$LocalizationPersistenceBackendFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class __$$LocalizationPersistenceBackendFailureImplCopyWithImpl<$Res>
    extends
        _$LocalizationFailureCopyWithImpl<
          $Res,
          _$LocalizationPersistenceBackendFailureImpl
        >
    implements _$$LocalizationPersistenceBackendFailureImplCopyWith<$Res> {
  __$$LocalizationPersistenceBackendFailureImplCopyWithImpl(
    _$LocalizationPersistenceBackendFailureImpl _value,
    $Res Function(_$LocalizationPersistenceBackendFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _$LocalizationPersistenceBackendFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        cause: freezed == cause ? _value.cause : cause,
      ),
    );
  }
}

/// @nodoc

class _$LocalizationPersistenceBackendFailureImpl
    implements LocalizationPersistenceBackendFailure {
  const _$LocalizationPersistenceBackendFailureImpl({
    required this.message,
    this.cause,
  });

  @override
  final String message;
  @override
  final Object? cause;

  @override
  String toString() {
    return 'LocalizationFailure.persistenceBackend(message: $message, cause: $cause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalizationPersistenceBackendFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(cause),
  );

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalizationPersistenceBackendFailureImplCopyWith<
    _$LocalizationPersistenceBackendFailureImpl
  >
  get copyWith =>
      __$$LocalizationPersistenceBackendFailureImplCopyWithImpl<
        _$LocalizationPersistenceBackendFailureImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) persistenceBackend,
    required TResult Function(String message, Object? cause) unsupportedLocale,
  }) {
    return persistenceBackend(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? persistenceBackend,
    TResult? Function(String message, Object? cause)? unsupportedLocale,
  }) {
    return persistenceBackend?.call(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? persistenceBackend,
    TResult Function(String message, Object? cause)? unsupportedLocale,
    required TResult orElse(),
  }) {
    if (persistenceBackend != null) {
      return persistenceBackend(message, cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalizationPersistenceBackendFailure value)
    persistenceBackend,
    required TResult Function(LocalizationUnsupportedLocaleFailure value)
    unsupportedLocale,
  }) {
    return persistenceBackend(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalizationPersistenceBackendFailure value)?
    persistenceBackend,
    TResult? Function(LocalizationUnsupportedLocaleFailure value)?
    unsupportedLocale,
  }) {
    return persistenceBackend?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalizationPersistenceBackendFailure value)?
    persistenceBackend,
    TResult Function(LocalizationUnsupportedLocaleFailure value)?
    unsupportedLocale,
    required TResult orElse(),
  }) {
    if (persistenceBackend != null) {
      return persistenceBackend(this);
    }
    return orElse();
  }
}

abstract class LocalizationPersistenceBackendFailure
    implements LocalizationFailure {
  const factory LocalizationPersistenceBackendFailure({
    required final String message,
    final Object? cause,
  }) = _$LocalizationPersistenceBackendFailureImpl;

  @override
  String get message;
  @override
  Object? get cause;

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalizationPersistenceBackendFailureImplCopyWith<
    _$LocalizationPersistenceBackendFailureImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LocalizationUnsupportedLocaleFailureImplCopyWith<$Res>
    implements $LocalizationFailureCopyWith<$Res> {
  factory _$$LocalizationUnsupportedLocaleFailureImplCopyWith(
    _$LocalizationUnsupportedLocaleFailureImpl value,
    $Res Function(_$LocalizationUnsupportedLocaleFailureImpl) then,
  ) = __$$LocalizationUnsupportedLocaleFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class __$$LocalizationUnsupportedLocaleFailureImplCopyWithImpl<$Res>
    extends
        _$LocalizationFailureCopyWithImpl<
          $Res,
          _$LocalizationUnsupportedLocaleFailureImpl
        >
    implements _$$LocalizationUnsupportedLocaleFailureImplCopyWith<$Res> {
  __$$LocalizationUnsupportedLocaleFailureImplCopyWithImpl(
    _$LocalizationUnsupportedLocaleFailureImpl _value,
    $Res Function(_$LocalizationUnsupportedLocaleFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _$LocalizationUnsupportedLocaleFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        cause: freezed == cause ? _value.cause : cause,
      ),
    );
  }
}

/// @nodoc

class _$LocalizationUnsupportedLocaleFailureImpl
    implements LocalizationUnsupportedLocaleFailure {
  const _$LocalizationUnsupportedLocaleFailureImpl({
    required this.message,
    this.cause,
  });

  @override
  final String message;
  @override
  final Object? cause;

  @override
  String toString() {
    return 'LocalizationFailure.unsupportedLocale(message: $message, cause: $cause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalizationUnsupportedLocaleFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(cause),
  );

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalizationUnsupportedLocaleFailureImplCopyWith<
    _$LocalizationUnsupportedLocaleFailureImpl
  >
  get copyWith =>
      __$$LocalizationUnsupportedLocaleFailureImplCopyWithImpl<
        _$LocalizationUnsupportedLocaleFailureImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) persistenceBackend,
    required TResult Function(String message, Object? cause) unsupportedLocale,
  }) {
    return unsupportedLocale(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? persistenceBackend,
    TResult? Function(String message, Object? cause)? unsupportedLocale,
  }) {
    return unsupportedLocale?.call(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? persistenceBackend,
    TResult Function(String message, Object? cause)? unsupportedLocale,
    required TResult orElse(),
  }) {
    if (unsupportedLocale != null) {
      return unsupportedLocale(message, cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalizationPersistenceBackendFailure value)
    persistenceBackend,
    required TResult Function(LocalizationUnsupportedLocaleFailure value)
    unsupportedLocale,
  }) {
    return unsupportedLocale(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalizationPersistenceBackendFailure value)?
    persistenceBackend,
    TResult? Function(LocalizationUnsupportedLocaleFailure value)?
    unsupportedLocale,
  }) {
    return unsupportedLocale?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalizationPersistenceBackendFailure value)?
    persistenceBackend,
    TResult Function(LocalizationUnsupportedLocaleFailure value)?
    unsupportedLocale,
    required TResult orElse(),
  }) {
    if (unsupportedLocale != null) {
      return unsupportedLocale(this);
    }
    return orElse();
  }
}

abstract class LocalizationUnsupportedLocaleFailure
    implements LocalizationFailure {
  const factory LocalizationUnsupportedLocaleFailure({
    required final String message,
    final Object? cause,
  }) = _$LocalizationUnsupportedLocaleFailureImpl;

  @override
  String get message;
  @override
  Object? get cause;

  /// Create a copy of LocalizationFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalizationUnsupportedLocaleFailureImplCopyWith<
    _$LocalizationUnsupportedLocaleFailureImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
