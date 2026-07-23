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
mixin _$StorageFailure {
  String get message => throw _privateConstructorUsedError;
  Object? get cause => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) notFound,
    required TResult Function(String message, Object? cause) serialization,
    required TResult Function(String message, Object? cause) backend,
    required TResult Function(String message, Object? cause) security,
    required TResult Function(String message, Object? cause)
    capabilityUnsupported,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? notFound,
    TResult? Function(String message, Object? cause)? serialization,
    TResult? Function(String message, Object? cause)? backend,
    TResult? Function(String message, Object? cause)? security,
    TResult? Function(String message, Object? cause)? capabilityUnsupported,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? notFound,
    TResult Function(String message, Object? cause)? serialization,
    TResult Function(String message, Object? cause)? backend,
    TResult Function(String message, Object? cause)? security,
    TResult Function(String message, Object? cause)? capabilityUnsupported,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StorageNotFoundFailure value) notFound,
    required TResult Function(StorageSerializationFailure value) serialization,
    required TResult Function(StorageBackendFailure value) backend,
    required TResult Function(StorageSecurityFailure value) security,
    required TResult Function(StorageCapabilityUnsupportedFailure value)
    capabilityUnsupported,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StorageNotFoundFailure value)? notFound,
    TResult? Function(StorageSerializationFailure value)? serialization,
    TResult? Function(StorageBackendFailure value)? backend,
    TResult? Function(StorageSecurityFailure value)? security,
    TResult? Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StorageNotFoundFailure value)? notFound,
    TResult Function(StorageSerializationFailure value)? serialization,
    TResult Function(StorageBackendFailure value)? backend,
    TResult Function(StorageSecurityFailure value)? security,
    TResult Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StorageFailureCopyWith<StorageFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorageFailureCopyWith<$Res> {
  factory $StorageFailureCopyWith(
    StorageFailure value,
    $Res Function(StorageFailure) then,
  ) = _$StorageFailureCopyWithImpl<$Res, StorageFailure>;
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class _$StorageFailureCopyWithImpl<$Res, $Val extends StorageFailure>
    implements $StorageFailureCopyWith<$Res> {
  _$StorageFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StorageFailure
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
abstract class _$$StorageNotFoundFailureImplCopyWith<$Res>
    implements $StorageFailureCopyWith<$Res> {
  factory _$$StorageNotFoundFailureImplCopyWith(
    _$StorageNotFoundFailureImpl value,
    $Res Function(_$StorageNotFoundFailureImpl) then,
  ) = __$$StorageNotFoundFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class __$$StorageNotFoundFailureImplCopyWithImpl<$Res>
    extends _$StorageFailureCopyWithImpl<$Res, _$StorageNotFoundFailureImpl>
    implements _$$StorageNotFoundFailureImplCopyWith<$Res> {
  __$$StorageNotFoundFailureImplCopyWithImpl(
    _$StorageNotFoundFailureImpl _value,
    $Res Function(_$StorageNotFoundFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _$StorageNotFoundFailureImpl(
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

class _$StorageNotFoundFailureImpl implements StorageNotFoundFailure {
  const _$StorageNotFoundFailureImpl({required this.message, this.cause});

  @override
  final String message;
  @override
  final Object? cause;

  @override
  String toString() {
    return 'StorageFailure.notFound(message: $message, cause: $cause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageNotFoundFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(cause),
  );

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageNotFoundFailureImplCopyWith<_$StorageNotFoundFailureImpl>
  get copyWith =>
      __$$StorageNotFoundFailureImplCopyWithImpl<_$StorageNotFoundFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) notFound,
    required TResult Function(String message, Object? cause) serialization,
    required TResult Function(String message, Object? cause) backend,
    required TResult Function(String message, Object? cause) security,
    required TResult Function(String message, Object? cause)
    capabilityUnsupported,
  }) {
    return notFound(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? notFound,
    TResult? Function(String message, Object? cause)? serialization,
    TResult? Function(String message, Object? cause)? backend,
    TResult? Function(String message, Object? cause)? security,
    TResult? Function(String message, Object? cause)? capabilityUnsupported,
  }) {
    return notFound?.call(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? notFound,
    TResult Function(String message, Object? cause)? serialization,
    TResult Function(String message, Object? cause)? backend,
    TResult Function(String message, Object? cause)? security,
    TResult Function(String message, Object? cause)? capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(message, cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StorageNotFoundFailure value) notFound,
    required TResult Function(StorageSerializationFailure value) serialization,
    required TResult Function(StorageBackendFailure value) backend,
    required TResult Function(StorageSecurityFailure value) security,
    required TResult Function(StorageCapabilityUnsupportedFailure value)
    capabilityUnsupported,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StorageNotFoundFailure value)? notFound,
    TResult? Function(StorageSerializationFailure value)? serialization,
    TResult? Function(StorageBackendFailure value)? backend,
    TResult? Function(StorageSecurityFailure value)? security,
    TResult? Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StorageNotFoundFailure value)? notFound,
    TResult Function(StorageSerializationFailure value)? serialization,
    TResult Function(StorageBackendFailure value)? backend,
    TResult Function(StorageSecurityFailure value)? security,
    TResult Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class StorageNotFoundFailure implements StorageFailure {
  const factory StorageNotFoundFailure({
    required final String message,
    final Object? cause,
  }) = _$StorageNotFoundFailureImpl;

  @override
  String get message;
  @override
  Object? get cause;

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageNotFoundFailureImplCopyWith<_$StorageNotFoundFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageSerializationFailureImplCopyWith<$Res>
    implements $StorageFailureCopyWith<$Res> {
  factory _$$StorageSerializationFailureImplCopyWith(
    _$StorageSerializationFailureImpl value,
    $Res Function(_$StorageSerializationFailureImpl) then,
  ) = __$$StorageSerializationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class __$$StorageSerializationFailureImplCopyWithImpl<$Res>
    extends
        _$StorageFailureCopyWithImpl<$Res, _$StorageSerializationFailureImpl>
    implements _$$StorageSerializationFailureImplCopyWith<$Res> {
  __$$StorageSerializationFailureImplCopyWithImpl(
    _$StorageSerializationFailureImpl _value,
    $Res Function(_$StorageSerializationFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _$StorageSerializationFailureImpl(
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

class _$StorageSerializationFailureImpl implements StorageSerializationFailure {
  const _$StorageSerializationFailureImpl({required this.message, this.cause});

  @override
  final String message;
  @override
  final Object? cause;

  @override
  String toString() {
    return 'StorageFailure.serialization(message: $message, cause: $cause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageSerializationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(cause),
  );

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageSerializationFailureImplCopyWith<_$StorageSerializationFailureImpl>
  get copyWith =>
      __$$StorageSerializationFailureImplCopyWithImpl<
        _$StorageSerializationFailureImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) notFound,
    required TResult Function(String message, Object? cause) serialization,
    required TResult Function(String message, Object? cause) backend,
    required TResult Function(String message, Object? cause) security,
    required TResult Function(String message, Object? cause)
    capabilityUnsupported,
  }) {
    return serialization(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? notFound,
    TResult? Function(String message, Object? cause)? serialization,
    TResult? Function(String message, Object? cause)? backend,
    TResult? Function(String message, Object? cause)? security,
    TResult? Function(String message, Object? cause)? capabilityUnsupported,
  }) {
    return serialization?.call(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? notFound,
    TResult Function(String message, Object? cause)? serialization,
    TResult Function(String message, Object? cause)? backend,
    TResult Function(String message, Object? cause)? security,
    TResult Function(String message, Object? cause)? capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (serialization != null) {
      return serialization(message, cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StorageNotFoundFailure value) notFound,
    required TResult Function(StorageSerializationFailure value) serialization,
    required TResult Function(StorageBackendFailure value) backend,
    required TResult Function(StorageSecurityFailure value) security,
    required TResult Function(StorageCapabilityUnsupportedFailure value)
    capabilityUnsupported,
  }) {
    return serialization(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StorageNotFoundFailure value)? notFound,
    TResult? Function(StorageSerializationFailure value)? serialization,
    TResult? Function(StorageBackendFailure value)? backend,
    TResult? Function(StorageSecurityFailure value)? security,
    TResult? Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
  }) {
    return serialization?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StorageNotFoundFailure value)? notFound,
    TResult Function(StorageSerializationFailure value)? serialization,
    TResult Function(StorageBackendFailure value)? backend,
    TResult Function(StorageSecurityFailure value)? security,
    TResult Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (serialization != null) {
      return serialization(this);
    }
    return orElse();
  }
}

abstract class StorageSerializationFailure implements StorageFailure {
  const factory StorageSerializationFailure({
    required final String message,
    final Object? cause,
  }) = _$StorageSerializationFailureImpl;

  @override
  String get message;
  @override
  Object? get cause;

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageSerializationFailureImplCopyWith<_$StorageSerializationFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageBackendFailureImplCopyWith<$Res>
    implements $StorageFailureCopyWith<$Res> {
  factory _$$StorageBackendFailureImplCopyWith(
    _$StorageBackendFailureImpl value,
    $Res Function(_$StorageBackendFailureImpl) then,
  ) = __$$StorageBackendFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class __$$StorageBackendFailureImplCopyWithImpl<$Res>
    extends _$StorageFailureCopyWithImpl<$Res, _$StorageBackendFailureImpl>
    implements _$$StorageBackendFailureImplCopyWith<$Res> {
  __$$StorageBackendFailureImplCopyWithImpl(
    _$StorageBackendFailureImpl _value,
    $Res Function(_$StorageBackendFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _$StorageBackendFailureImpl(
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

class _$StorageBackendFailureImpl implements StorageBackendFailure {
  const _$StorageBackendFailureImpl({required this.message, this.cause});

  @override
  final String message;
  @override
  final Object? cause;

  @override
  String toString() {
    return 'StorageFailure.backend(message: $message, cause: $cause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageBackendFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(cause),
  );

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageBackendFailureImplCopyWith<_$StorageBackendFailureImpl>
  get copyWith =>
      __$$StorageBackendFailureImplCopyWithImpl<_$StorageBackendFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) notFound,
    required TResult Function(String message, Object? cause) serialization,
    required TResult Function(String message, Object? cause) backend,
    required TResult Function(String message, Object? cause) security,
    required TResult Function(String message, Object? cause)
    capabilityUnsupported,
  }) {
    return backend(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? notFound,
    TResult? Function(String message, Object? cause)? serialization,
    TResult? Function(String message, Object? cause)? backend,
    TResult? Function(String message, Object? cause)? security,
    TResult? Function(String message, Object? cause)? capabilityUnsupported,
  }) {
    return backend?.call(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? notFound,
    TResult Function(String message, Object? cause)? serialization,
    TResult Function(String message, Object? cause)? backend,
    TResult Function(String message, Object? cause)? security,
    TResult Function(String message, Object? cause)? capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (backend != null) {
      return backend(message, cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StorageNotFoundFailure value) notFound,
    required TResult Function(StorageSerializationFailure value) serialization,
    required TResult Function(StorageBackendFailure value) backend,
    required TResult Function(StorageSecurityFailure value) security,
    required TResult Function(StorageCapabilityUnsupportedFailure value)
    capabilityUnsupported,
  }) {
    return backend(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StorageNotFoundFailure value)? notFound,
    TResult? Function(StorageSerializationFailure value)? serialization,
    TResult? Function(StorageBackendFailure value)? backend,
    TResult? Function(StorageSecurityFailure value)? security,
    TResult? Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
  }) {
    return backend?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StorageNotFoundFailure value)? notFound,
    TResult Function(StorageSerializationFailure value)? serialization,
    TResult Function(StorageBackendFailure value)? backend,
    TResult Function(StorageSecurityFailure value)? security,
    TResult Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (backend != null) {
      return backend(this);
    }
    return orElse();
  }
}

abstract class StorageBackendFailure implements StorageFailure {
  const factory StorageBackendFailure({
    required final String message,
    final Object? cause,
  }) = _$StorageBackendFailureImpl;

  @override
  String get message;
  @override
  Object? get cause;

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageBackendFailureImplCopyWith<_$StorageBackendFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageSecurityFailureImplCopyWith<$Res>
    implements $StorageFailureCopyWith<$Res> {
  factory _$$StorageSecurityFailureImplCopyWith(
    _$StorageSecurityFailureImpl value,
    $Res Function(_$StorageSecurityFailureImpl) then,
  ) = __$$StorageSecurityFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class __$$StorageSecurityFailureImplCopyWithImpl<$Res>
    extends _$StorageFailureCopyWithImpl<$Res, _$StorageSecurityFailureImpl>
    implements _$$StorageSecurityFailureImplCopyWith<$Res> {
  __$$StorageSecurityFailureImplCopyWithImpl(
    _$StorageSecurityFailureImpl _value,
    $Res Function(_$StorageSecurityFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _$StorageSecurityFailureImpl(
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

class _$StorageSecurityFailureImpl implements StorageSecurityFailure {
  const _$StorageSecurityFailureImpl({required this.message, this.cause});

  @override
  final String message;
  @override
  final Object? cause;

  @override
  String toString() {
    return 'StorageFailure.security(message: $message, cause: $cause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageSecurityFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(cause),
  );

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageSecurityFailureImplCopyWith<_$StorageSecurityFailureImpl>
  get copyWith =>
      __$$StorageSecurityFailureImplCopyWithImpl<_$StorageSecurityFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) notFound,
    required TResult Function(String message, Object? cause) serialization,
    required TResult Function(String message, Object? cause) backend,
    required TResult Function(String message, Object? cause) security,
    required TResult Function(String message, Object? cause)
    capabilityUnsupported,
  }) {
    return security(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? notFound,
    TResult? Function(String message, Object? cause)? serialization,
    TResult? Function(String message, Object? cause)? backend,
    TResult? Function(String message, Object? cause)? security,
    TResult? Function(String message, Object? cause)? capabilityUnsupported,
  }) {
    return security?.call(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? notFound,
    TResult Function(String message, Object? cause)? serialization,
    TResult Function(String message, Object? cause)? backend,
    TResult Function(String message, Object? cause)? security,
    TResult Function(String message, Object? cause)? capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (security != null) {
      return security(message, cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StorageNotFoundFailure value) notFound,
    required TResult Function(StorageSerializationFailure value) serialization,
    required TResult Function(StorageBackendFailure value) backend,
    required TResult Function(StorageSecurityFailure value) security,
    required TResult Function(StorageCapabilityUnsupportedFailure value)
    capabilityUnsupported,
  }) {
    return security(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StorageNotFoundFailure value)? notFound,
    TResult? Function(StorageSerializationFailure value)? serialization,
    TResult? Function(StorageBackendFailure value)? backend,
    TResult? Function(StorageSecurityFailure value)? security,
    TResult? Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
  }) {
    return security?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StorageNotFoundFailure value)? notFound,
    TResult Function(StorageSerializationFailure value)? serialization,
    TResult Function(StorageBackendFailure value)? backend,
    TResult Function(StorageSecurityFailure value)? security,
    TResult Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (security != null) {
      return security(this);
    }
    return orElse();
  }
}

abstract class StorageSecurityFailure implements StorageFailure {
  const factory StorageSecurityFailure({
    required final String message,
    final Object? cause,
  }) = _$StorageSecurityFailureImpl;

  @override
  String get message;
  @override
  Object? get cause;

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageSecurityFailureImplCopyWith<_$StorageSecurityFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageCapabilityUnsupportedFailureImplCopyWith<$Res>
    implements $StorageFailureCopyWith<$Res> {
  factory _$$StorageCapabilityUnsupportedFailureImplCopyWith(
    _$StorageCapabilityUnsupportedFailureImpl value,
    $Res Function(_$StorageCapabilityUnsupportedFailureImpl) then,
  ) = __$$StorageCapabilityUnsupportedFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? cause});
}

/// @nodoc
class __$$StorageCapabilityUnsupportedFailureImplCopyWithImpl<$Res>
    extends
        _$StorageFailureCopyWithImpl<
          $Res,
          _$StorageCapabilityUnsupportedFailureImpl
        >
    implements _$$StorageCapabilityUnsupportedFailureImplCopyWith<$Res> {
  __$$StorageCapabilityUnsupportedFailureImplCopyWithImpl(
    _$StorageCapabilityUnsupportedFailureImpl _value,
    $Res Function(_$StorageCapabilityUnsupportedFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? cause = freezed}) {
    return _then(
      _$StorageCapabilityUnsupportedFailureImpl(
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

class _$StorageCapabilityUnsupportedFailureImpl
    implements StorageCapabilityUnsupportedFailure {
  const _$StorageCapabilityUnsupportedFailureImpl({
    required this.message,
    this.cause,
  });

  @override
  final String message;
  @override
  final Object? cause;

  @override
  String toString() {
    return 'StorageFailure.capabilityUnsupported(message: $message, cause: $cause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageCapabilityUnsupportedFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(cause),
  );

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageCapabilityUnsupportedFailureImplCopyWith<
    _$StorageCapabilityUnsupportedFailureImpl
  >
  get copyWith =>
      __$$StorageCapabilityUnsupportedFailureImplCopyWithImpl<
        _$StorageCapabilityUnsupportedFailureImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? cause) notFound,
    required TResult Function(String message, Object? cause) serialization,
    required TResult Function(String message, Object? cause) backend,
    required TResult Function(String message, Object? cause) security,
    required TResult Function(String message, Object? cause)
    capabilityUnsupported,
  }) {
    return capabilityUnsupported(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? cause)? notFound,
    TResult? Function(String message, Object? cause)? serialization,
    TResult? Function(String message, Object? cause)? backend,
    TResult? Function(String message, Object? cause)? security,
    TResult? Function(String message, Object? cause)? capabilityUnsupported,
  }) {
    return capabilityUnsupported?.call(message, cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? cause)? notFound,
    TResult Function(String message, Object? cause)? serialization,
    TResult Function(String message, Object? cause)? backend,
    TResult Function(String message, Object? cause)? security,
    TResult Function(String message, Object? cause)? capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (capabilityUnsupported != null) {
      return capabilityUnsupported(message, cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StorageNotFoundFailure value) notFound,
    required TResult Function(StorageSerializationFailure value) serialization,
    required TResult Function(StorageBackendFailure value) backend,
    required TResult Function(StorageSecurityFailure value) security,
    required TResult Function(StorageCapabilityUnsupportedFailure value)
    capabilityUnsupported,
  }) {
    return capabilityUnsupported(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StorageNotFoundFailure value)? notFound,
    TResult? Function(StorageSerializationFailure value)? serialization,
    TResult? Function(StorageBackendFailure value)? backend,
    TResult? Function(StorageSecurityFailure value)? security,
    TResult? Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
  }) {
    return capabilityUnsupported?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StorageNotFoundFailure value)? notFound,
    TResult Function(StorageSerializationFailure value)? serialization,
    TResult Function(StorageBackendFailure value)? backend,
    TResult Function(StorageSecurityFailure value)? security,
    TResult Function(StorageCapabilityUnsupportedFailure value)?
    capabilityUnsupported,
    required TResult orElse(),
  }) {
    if (capabilityUnsupported != null) {
      return capabilityUnsupported(this);
    }
    return orElse();
  }
}

abstract class StorageCapabilityUnsupportedFailure implements StorageFailure {
  const factory StorageCapabilityUnsupportedFailure({
    required final String message,
    final Object? cause,
  }) = _$StorageCapabilityUnsupportedFailureImpl;

  @override
  String get message;
  @override
  Object? get cause;

  /// Create a copy of StorageFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageCapabilityUnsupportedFailureImplCopyWith<
    _$StorageCapabilityUnsupportedFailureImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
