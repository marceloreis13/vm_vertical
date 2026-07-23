// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NotificationPayload {
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  NotificationKind get kind => throw _privateConstructorUsedError;
  Map<String, Object?> get data => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPayloadCopyWith<NotificationPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPayloadCopyWith<$Res> {
  factory $NotificationPayloadCopyWith(
    NotificationPayload value,
    $Res Function(NotificationPayload) then,
  ) = _$NotificationPayloadCopyWithImpl<$Res, NotificationPayload>;
  @useResult
  $Res call({
    String title,
    String body,
    NotificationKind kind,
    Map<String, Object?> data,
  });
}

/// @nodoc
class _$NotificationPayloadCopyWithImpl<$Res, $Val extends NotificationPayload>
    implements $NotificationPayloadCopyWith<$Res> {
  _$NotificationPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? kind = null,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as NotificationKind,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, Object?>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationPayloadImplCopyWith<$Res>
    implements $NotificationPayloadCopyWith<$Res> {
  factory _$$NotificationPayloadImplCopyWith(
    _$NotificationPayloadImpl value,
    $Res Function(_$NotificationPayloadImpl) then,
  ) = __$$NotificationPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String body,
    NotificationKind kind,
    Map<String, Object?> data,
  });
}

/// @nodoc
class __$$NotificationPayloadImplCopyWithImpl<$Res>
    extends _$NotificationPayloadCopyWithImpl<$Res, _$NotificationPayloadImpl>
    implements _$$NotificationPayloadImplCopyWith<$Res> {
  __$$NotificationPayloadImplCopyWithImpl(
    _$NotificationPayloadImpl _value,
    $Res Function(_$NotificationPayloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? kind = null,
    Object? data = null,
  }) {
    return _then(
      _$NotificationPayloadImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as NotificationKind,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}

/// @nodoc

class _$NotificationPayloadImpl implements _NotificationPayload {
  const _$NotificationPayloadImpl({
    required this.title,
    required this.body,
    required this.kind,
    final Map<String, Object?> data = const <String, Object?>{},
  }) : _data = data;

  @override
  final String title;
  @override
  final String body;
  @override
  final NotificationKind kind;
  final Map<String, Object?> _data;
  @override
  @JsonKey()
  Map<String, Object?> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'NotificationPayload(title: $title, body: $body, kind: $kind, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPayloadImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    body,
    kind,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPayloadImplCopyWith<_$NotificationPayloadImpl> get copyWith =>
      __$$NotificationPayloadImplCopyWithImpl<_$NotificationPayloadImpl>(
        this,
        _$identity,
      );
}

abstract class _NotificationPayload implements NotificationPayload {
  const factory _NotificationPayload({
    required final String title,
    required final String body,
    required final NotificationKind kind,
    final Map<String, Object?> data,
  }) = _$NotificationPayloadImpl;

  @override
  String get title;
  @override
  String get body;
  @override
  NotificationKind get kind;
  @override
  Map<String, Object?> get data;

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPayloadImplCopyWith<_$NotificationPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
