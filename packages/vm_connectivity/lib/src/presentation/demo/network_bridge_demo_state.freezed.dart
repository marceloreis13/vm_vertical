// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_bridge_demo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NetworkBridgeDemoState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(bool heldOffline) pending,
    required TResult Function() succeeded,
    required TResult Function(String message) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(bool heldOffline)? pending,
    TResult? Function()? succeeded,
    TResult? Function(String message)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(bool heldOffline)? pending,
    TResult Function()? succeeded,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkBridgeIdle value) idle,
    required TResult Function(NetworkBridgePending value) pending,
    required TResult Function(NetworkBridgeSucceeded value) succeeded,
    required TResult Function(NetworkBridgeFailed value) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkBridgeIdle value)? idle,
    TResult? Function(NetworkBridgePending value)? pending,
    TResult? Function(NetworkBridgeSucceeded value)? succeeded,
    TResult? Function(NetworkBridgeFailed value)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkBridgeIdle value)? idle,
    TResult Function(NetworkBridgePending value)? pending,
    TResult Function(NetworkBridgeSucceeded value)? succeeded,
    TResult Function(NetworkBridgeFailed value)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkBridgeDemoStateCopyWith<$Res> {
  factory $NetworkBridgeDemoStateCopyWith(
    NetworkBridgeDemoState value,
    $Res Function(NetworkBridgeDemoState) then,
  ) = _$NetworkBridgeDemoStateCopyWithImpl<$Res, NetworkBridgeDemoState>;
}

/// @nodoc
class _$NetworkBridgeDemoStateCopyWithImpl<
  $Res,
  $Val extends NetworkBridgeDemoState
>
    implements $NetworkBridgeDemoStateCopyWith<$Res> {
  _$NetworkBridgeDemoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$NetworkBridgeIdleImplCopyWith<$Res> {
  factory _$$NetworkBridgeIdleImplCopyWith(
    _$NetworkBridgeIdleImpl value,
    $Res Function(_$NetworkBridgeIdleImpl) then,
  ) = __$$NetworkBridgeIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkBridgeIdleImplCopyWithImpl<$Res>
    extends _$NetworkBridgeDemoStateCopyWithImpl<$Res, _$NetworkBridgeIdleImpl>
    implements _$$NetworkBridgeIdleImplCopyWith<$Res> {
  __$$NetworkBridgeIdleImplCopyWithImpl(
    _$NetworkBridgeIdleImpl _value,
    $Res Function(_$NetworkBridgeIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkBridgeIdleImpl implements NetworkBridgeIdle {
  const _$NetworkBridgeIdleImpl();

  @override
  String toString() {
    return 'NetworkBridgeDemoState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkBridgeIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(bool heldOffline) pending,
    required TResult Function() succeeded,
    required TResult Function(String message) failed,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(bool heldOffline)? pending,
    TResult? Function()? succeeded,
    TResult? Function(String message)? failed,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(bool heldOffline)? pending,
    TResult Function()? succeeded,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkBridgeIdle value) idle,
    required TResult Function(NetworkBridgePending value) pending,
    required TResult Function(NetworkBridgeSucceeded value) succeeded,
    required TResult Function(NetworkBridgeFailed value) failed,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkBridgeIdle value)? idle,
    TResult? Function(NetworkBridgePending value)? pending,
    TResult? Function(NetworkBridgeSucceeded value)? succeeded,
    TResult? Function(NetworkBridgeFailed value)? failed,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkBridgeIdle value)? idle,
    TResult Function(NetworkBridgePending value)? pending,
    TResult Function(NetworkBridgeSucceeded value)? succeeded,
    TResult Function(NetworkBridgeFailed value)? failed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class NetworkBridgeIdle implements NetworkBridgeDemoState {
  const factory NetworkBridgeIdle() = _$NetworkBridgeIdleImpl;
}

/// @nodoc
abstract class _$$NetworkBridgePendingImplCopyWith<$Res> {
  factory _$$NetworkBridgePendingImplCopyWith(
    _$NetworkBridgePendingImpl value,
    $Res Function(_$NetworkBridgePendingImpl) then,
  ) = __$$NetworkBridgePendingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool heldOffline});
}

/// @nodoc
class __$$NetworkBridgePendingImplCopyWithImpl<$Res>
    extends
        _$NetworkBridgeDemoStateCopyWithImpl<$Res, _$NetworkBridgePendingImpl>
    implements _$$NetworkBridgePendingImplCopyWith<$Res> {
  __$$NetworkBridgePendingImplCopyWithImpl(
    _$NetworkBridgePendingImpl _value,
    $Res Function(_$NetworkBridgePendingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? heldOffline = null}) {
    return _then(
      _$NetworkBridgePendingImpl(
        heldOffline: null == heldOffline
            ? _value.heldOffline
            : heldOffline // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$NetworkBridgePendingImpl implements NetworkBridgePending {
  const _$NetworkBridgePendingImpl({required this.heldOffline});

  @override
  final bool heldOffline;

  @override
  String toString() {
    return 'NetworkBridgeDemoState.pending(heldOffline: $heldOffline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkBridgePendingImpl &&
            (identical(other.heldOffline, heldOffline) ||
                other.heldOffline == heldOffline));
  }

  @override
  int get hashCode => Object.hash(runtimeType, heldOffline);

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkBridgePendingImplCopyWith<_$NetworkBridgePendingImpl>
  get copyWith =>
      __$$NetworkBridgePendingImplCopyWithImpl<_$NetworkBridgePendingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(bool heldOffline) pending,
    required TResult Function() succeeded,
    required TResult Function(String message) failed,
  }) {
    return pending(heldOffline);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(bool heldOffline)? pending,
    TResult? Function()? succeeded,
    TResult? Function(String message)? failed,
  }) {
    return pending?.call(heldOffline);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(bool heldOffline)? pending,
    TResult Function()? succeeded,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending(heldOffline);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkBridgeIdle value) idle,
    required TResult Function(NetworkBridgePending value) pending,
    required TResult Function(NetworkBridgeSucceeded value) succeeded,
    required TResult Function(NetworkBridgeFailed value) failed,
  }) {
    return pending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkBridgeIdle value)? idle,
    TResult? Function(NetworkBridgePending value)? pending,
    TResult? Function(NetworkBridgeSucceeded value)? succeeded,
    TResult? Function(NetworkBridgeFailed value)? failed,
  }) {
    return pending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkBridgeIdle value)? idle,
    TResult Function(NetworkBridgePending value)? pending,
    TResult Function(NetworkBridgeSucceeded value)? succeeded,
    TResult Function(NetworkBridgeFailed value)? failed,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending(this);
    }
    return orElse();
  }
}

abstract class NetworkBridgePending implements NetworkBridgeDemoState {
  const factory NetworkBridgePending({required final bool heldOffline}) =
      _$NetworkBridgePendingImpl;

  bool get heldOffline;

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkBridgePendingImplCopyWith<_$NetworkBridgePendingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkBridgeSucceededImplCopyWith<$Res> {
  factory _$$NetworkBridgeSucceededImplCopyWith(
    _$NetworkBridgeSucceededImpl value,
    $Res Function(_$NetworkBridgeSucceededImpl) then,
  ) = __$$NetworkBridgeSucceededImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkBridgeSucceededImplCopyWithImpl<$Res>
    extends
        _$NetworkBridgeDemoStateCopyWithImpl<$Res, _$NetworkBridgeSucceededImpl>
    implements _$$NetworkBridgeSucceededImplCopyWith<$Res> {
  __$$NetworkBridgeSucceededImplCopyWithImpl(
    _$NetworkBridgeSucceededImpl _value,
    $Res Function(_$NetworkBridgeSucceededImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkBridgeSucceededImpl implements NetworkBridgeSucceeded {
  const _$NetworkBridgeSucceededImpl();

  @override
  String toString() {
    return 'NetworkBridgeDemoState.succeeded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkBridgeSucceededImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(bool heldOffline) pending,
    required TResult Function() succeeded,
    required TResult Function(String message) failed,
  }) {
    return succeeded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(bool heldOffline)? pending,
    TResult? Function()? succeeded,
    TResult? Function(String message)? failed,
  }) {
    return succeeded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(bool heldOffline)? pending,
    TResult Function()? succeeded,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (succeeded != null) {
      return succeeded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkBridgeIdle value) idle,
    required TResult Function(NetworkBridgePending value) pending,
    required TResult Function(NetworkBridgeSucceeded value) succeeded,
    required TResult Function(NetworkBridgeFailed value) failed,
  }) {
    return succeeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkBridgeIdle value)? idle,
    TResult? Function(NetworkBridgePending value)? pending,
    TResult? Function(NetworkBridgeSucceeded value)? succeeded,
    TResult? Function(NetworkBridgeFailed value)? failed,
  }) {
    return succeeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkBridgeIdle value)? idle,
    TResult Function(NetworkBridgePending value)? pending,
    TResult Function(NetworkBridgeSucceeded value)? succeeded,
    TResult Function(NetworkBridgeFailed value)? failed,
    required TResult orElse(),
  }) {
    if (succeeded != null) {
      return succeeded(this);
    }
    return orElse();
  }
}

abstract class NetworkBridgeSucceeded implements NetworkBridgeDemoState {
  const factory NetworkBridgeSucceeded() = _$NetworkBridgeSucceededImpl;
}

/// @nodoc
abstract class _$$NetworkBridgeFailedImplCopyWith<$Res> {
  factory _$$NetworkBridgeFailedImplCopyWith(
    _$NetworkBridgeFailedImpl value,
    $Res Function(_$NetworkBridgeFailedImpl) then,
  ) = __$$NetworkBridgeFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkBridgeFailedImplCopyWithImpl<$Res>
    extends
        _$NetworkBridgeDemoStateCopyWithImpl<$Res, _$NetworkBridgeFailedImpl>
    implements _$$NetworkBridgeFailedImplCopyWith<$Res> {
  __$$NetworkBridgeFailedImplCopyWithImpl(
    _$NetworkBridgeFailedImpl _value,
    $Res Function(_$NetworkBridgeFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NetworkBridgeFailedImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NetworkBridgeFailedImpl implements NetworkBridgeFailed {
  const _$NetworkBridgeFailedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'NetworkBridgeDemoState.failed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkBridgeFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkBridgeFailedImplCopyWith<_$NetworkBridgeFailedImpl> get copyWith =>
      __$$NetworkBridgeFailedImplCopyWithImpl<_$NetworkBridgeFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(bool heldOffline) pending,
    required TResult Function() succeeded,
    required TResult Function(String message) failed,
  }) {
    return failed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(bool heldOffline)? pending,
    TResult? Function()? succeeded,
    TResult? Function(String message)? failed,
  }) {
    return failed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(bool heldOffline)? pending,
    TResult Function()? succeeded,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkBridgeIdle value) idle,
    required TResult Function(NetworkBridgePending value) pending,
    required TResult Function(NetworkBridgeSucceeded value) succeeded,
    required TResult Function(NetworkBridgeFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkBridgeIdle value)? idle,
    TResult? Function(NetworkBridgePending value)? pending,
    TResult? Function(NetworkBridgeSucceeded value)? succeeded,
    TResult? Function(NetworkBridgeFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkBridgeIdle value)? idle,
    TResult Function(NetworkBridgePending value)? pending,
    TResult Function(NetworkBridgeSucceeded value)? succeeded,
    TResult Function(NetworkBridgeFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class NetworkBridgeFailed implements NetworkBridgeDemoState {
  const factory NetworkBridgeFailed(final String message) =
      _$NetworkBridgeFailedImpl;

  String get message;

  /// Create a copy of NetworkBridgeDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkBridgeFailedImplCopyWith<_$NetworkBridgeFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
