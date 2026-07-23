// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connectivity_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ConnectivityState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ConnectionType type) online,
    required TResult Function() offline,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ConnectionType type)? online,
    TResult? Function()? offline,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ConnectionType type)? online,
    TResult Function()? offline,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConnectivityOnline value) online,
    required TResult Function(ConnectivityOffline value) offline,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConnectivityOnline value)? online,
    TResult? Function(ConnectivityOffline value)? offline,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConnectivityOnline value)? online,
    TResult Function(ConnectivityOffline value)? offline,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectivityStateCopyWith<$Res> {
  factory $ConnectivityStateCopyWith(
    ConnectivityState value,
    $Res Function(ConnectivityState) then,
  ) = _$ConnectivityStateCopyWithImpl<$Res, ConnectivityState>;
}

/// @nodoc
class _$ConnectivityStateCopyWithImpl<$Res, $Val extends ConnectivityState>
    implements $ConnectivityStateCopyWith<$Res> {
  _$ConnectivityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ConnectivityOnlineImplCopyWith<$Res> {
  factory _$$ConnectivityOnlineImplCopyWith(
    _$ConnectivityOnlineImpl value,
    $Res Function(_$ConnectivityOnlineImpl) then,
  ) = __$$ConnectivityOnlineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ConnectionType type});
}

/// @nodoc
class __$$ConnectivityOnlineImplCopyWithImpl<$Res>
    extends _$ConnectivityStateCopyWithImpl<$Res, _$ConnectivityOnlineImpl>
    implements _$$ConnectivityOnlineImplCopyWith<$Res> {
  __$$ConnectivityOnlineImplCopyWithImpl(
    _$ConnectivityOnlineImpl _value,
    $Res Function(_$ConnectivityOnlineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null}) {
    return _then(
      _$ConnectivityOnlineImpl(
        null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ConnectionType,
      ),
    );
  }
}

/// @nodoc

class _$ConnectivityOnlineImpl extends ConnectivityOnline {
  const _$ConnectivityOnlineImpl(this.type) : super._();

  @override
  final ConnectionType type;

  @override
  String toString() {
    return 'ConnectivityState.online(type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectivityOnlineImpl &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type);

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectivityOnlineImplCopyWith<_$ConnectivityOnlineImpl> get copyWith =>
      __$$ConnectivityOnlineImplCopyWithImpl<_$ConnectivityOnlineImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ConnectionType type) online,
    required TResult Function() offline,
  }) {
    return online(type);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ConnectionType type)? online,
    TResult? Function()? offline,
  }) {
    return online?.call(type);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ConnectionType type)? online,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(type);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConnectivityOnline value) online,
    required TResult Function(ConnectivityOffline value) offline,
  }) {
    return online(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConnectivityOnline value)? online,
    TResult? Function(ConnectivityOffline value)? offline,
  }) {
    return online?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConnectivityOnline value)? online,
    TResult Function(ConnectivityOffline value)? offline,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(this);
    }
    return orElse();
  }
}

abstract class ConnectivityOnline extends ConnectivityState {
  const factory ConnectivityOnline(final ConnectionType type) =
      _$ConnectivityOnlineImpl;
  const ConnectivityOnline._() : super._();

  ConnectionType get type;

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectivityOnlineImplCopyWith<_$ConnectivityOnlineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectivityOfflineImplCopyWith<$Res> {
  factory _$$ConnectivityOfflineImplCopyWith(
    _$ConnectivityOfflineImpl value,
    $Res Function(_$ConnectivityOfflineImpl) then,
  ) = __$$ConnectivityOfflineImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectivityOfflineImplCopyWithImpl<$Res>
    extends _$ConnectivityStateCopyWithImpl<$Res, _$ConnectivityOfflineImpl>
    implements _$$ConnectivityOfflineImplCopyWith<$Res> {
  __$$ConnectivityOfflineImplCopyWithImpl(
    _$ConnectivityOfflineImpl _value,
    $Res Function(_$ConnectivityOfflineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ConnectivityOfflineImpl extends ConnectivityOffline {
  const _$ConnectivityOfflineImpl() : super._();

  @override
  String toString() {
    return 'ConnectivityState.offline()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectivityOfflineImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ConnectionType type) online,
    required TResult Function() offline,
  }) {
    return offline();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ConnectionType type)? online,
    TResult? Function()? offline,
  }) {
    return offline?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ConnectionType type)? online,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConnectivityOnline value) online,
    required TResult Function(ConnectivityOffline value) offline,
  }) {
    return offline(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConnectivityOnline value)? online,
    TResult? Function(ConnectivityOffline value)? offline,
  }) {
    return offline?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConnectivityOnline value)? online,
    TResult Function(ConnectivityOffline value)? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline(this);
    }
    return orElse();
  }
}

abstract class ConnectivityOffline extends ConnectivityState {
  const factory ConnectivityOffline() = _$ConnectivityOfflineImpl;
  const ConnectivityOffline._() : super._();
}
