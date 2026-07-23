// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_demo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NotificationDemoState {
  String? get token => throw _privateConstructorUsedError;
  List<NotificationPayload> get receivedLog =>
      throw _privateConstructorUsedError;
  List<String> get scheduledIds => throw _privateConstructorUsedError;
  String? get lastFailure => throw _privateConstructorUsedError;

  /// Create a copy of NotificationDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationDemoStateCopyWith<NotificationDemoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationDemoStateCopyWith<$Res> {
  factory $NotificationDemoStateCopyWith(
    NotificationDemoState value,
    $Res Function(NotificationDemoState) then,
  ) = _$NotificationDemoStateCopyWithImpl<$Res, NotificationDemoState>;
  @useResult
  $Res call({
    String? token,
    List<NotificationPayload> receivedLog,
    List<String> scheduledIds,
    String? lastFailure,
  });
}

/// @nodoc
class _$NotificationDemoStateCopyWithImpl<
  $Res,
  $Val extends NotificationDemoState
>
    implements $NotificationDemoStateCopyWith<$Res> {
  _$NotificationDemoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? receivedLog = null,
    Object? scheduledIds = null,
    Object? lastFailure = freezed,
  }) {
    return _then(
      _value.copyWith(
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            receivedLog: null == receivedLog
                ? _value.receivedLog
                : receivedLog // ignore: cast_nullable_to_non_nullable
                      as List<NotificationPayload>,
            scheduledIds: null == scheduledIds
                ? _value.scheduledIds
                : scheduledIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            lastFailure: freezed == lastFailure
                ? _value.lastFailure
                : lastFailure // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationDemoStateImplCopyWith<$Res>
    implements $NotificationDemoStateCopyWith<$Res> {
  factory _$$NotificationDemoStateImplCopyWith(
    _$NotificationDemoStateImpl value,
    $Res Function(_$NotificationDemoStateImpl) then,
  ) = __$$NotificationDemoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? token,
    List<NotificationPayload> receivedLog,
    List<String> scheduledIds,
    String? lastFailure,
  });
}

/// @nodoc
class __$$NotificationDemoStateImplCopyWithImpl<$Res>
    extends
        _$NotificationDemoStateCopyWithImpl<$Res, _$NotificationDemoStateImpl>
    implements _$$NotificationDemoStateImplCopyWith<$Res> {
  __$$NotificationDemoStateImplCopyWithImpl(
    _$NotificationDemoStateImpl _value,
    $Res Function(_$NotificationDemoStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? receivedLog = null,
    Object? scheduledIds = null,
    Object? lastFailure = freezed,
  }) {
    return _then(
      _$NotificationDemoStateImpl(
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedLog: null == receivedLog
            ? _value._receivedLog
            : receivedLog // ignore: cast_nullable_to_non_nullable
                  as List<NotificationPayload>,
        scheduledIds: null == scheduledIds
            ? _value._scheduledIds
            : scheduledIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastFailure: freezed == lastFailure
            ? _value.lastFailure
            : lastFailure // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$NotificationDemoStateImpl implements _NotificationDemoState {
  const _$NotificationDemoStateImpl({
    this.token,
    final List<NotificationPayload> receivedLog = const <NotificationPayload>[],
    final List<String> scheduledIds = const <String>[],
    this.lastFailure,
  }) : _receivedLog = receivedLog,
       _scheduledIds = scheduledIds;

  @override
  final String? token;
  final List<NotificationPayload> _receivedLog;
  @override
  @JsonKey()
  List<NotificationPayload> get receivedLog {
    if (_receivedLog is EqualUnmodifiableListView) return _receivedLog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receivedLog);
  }

  final List<String> _scheduledIds;
  @override
  @JsonKey()
  List<String> get scheduledIds {
    if (_scheduledIds is EqualUnmodifiableListView) return _scheduledIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scheduledIds);
  }

  @override
  final String? lastFailure;

  @override
  String toString() {
    return 'NotificationDemoState(token: $token, receivedLog: $receivedLog, scheduledIds: $scheduledIds, lastFailure: $lastFailure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationDemoStateImpl &&
            (identical(other.token, token) || other.token == token) &&
            const DeepCollectionEquality().equals(
              other._receivedLog,
              _receivedLog,
            ) &&
            const DeepCollectionEquality().equals(
              other._scheduledIds,
              _scheduledIds,
            ) &&
            (identical(other.lastFailure, lastFailure) ||
                other.lastFailure == lastFailure));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    const DeepCollectionEquality().hash(_receivedLog),
    const DeepCollectionEquality().hash(_scheduledIds),
    lastFailure,
  );

  /// Create a copy of NotificationDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationDemoStateImplCopyWith<_$NotificationDemoStateImpl>
  get copyWith =>
      __$$NotificationDemoStateImplCopyWithImpl<_$NotificationDemoStateImpl>(
        this,
        _$identity,
      );
}

abstract class _NotificationDemoState implements NotificationDemoState {
  const factory _NotificationDemoState({
    final String? token,
    final List<NotificationPayload> receivedLog,
    final List<String> scheduledIds,
    final String? lastFailure,
  }) = _$NotificationDemoStateImpl;

  @override
  String? get token;
  @override
  List<NotificationPayload> get receivedLog;
  @override
  List<String> get scheduledIds;
  @override
  String? get lastFailure;

  /// Create a copy of NotificationDemoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationDemoStateImplCopyWith<_$NotificationDemoStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
