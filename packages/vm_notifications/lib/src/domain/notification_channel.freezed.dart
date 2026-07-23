// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_channel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NotificationChannel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of NotificationChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationChannelCopyWith<NotificationChannel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationChannelCopyWith<$Res> {
  factory $NotificationChannelCopyWith(
    NotificationChannel value,
    $Res Function(NotificationChannel) then,
  ) = _$NotificationChannelCopyWithImpl<$Res, NotificationChannel>;
  @useResult
  $Res call({String id, String name, String? description});
}

/// @nodoc
class _$NotificationChannelCopyWithImpl<$Res, $Val extends NotificationChannel>
    implements $NotificationChannelCopyWith<$Res> {
  _$NotificationChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationChannelImplCopyWith<$Res>
    implements $NotificationChannelCopyWith<$Res> {
  factory _$$NotificationChannelImplCopyWith(
    _$NotificationChannelImpl value,
    $Res Function(_$NotificationChannelImpl) then,
  ) = __$$NotificationChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? description});
}

/// @nodoc
class __$$NotificationChannelImplCopyWithImpl<$Res>
    extends _$NotificationChannelCopyWithImpl<$Res, _$NotificationChannelImpl>
    implements _$$NotificationChannelImplCopyWith<$Res> {
  __$$NotificationChannelImplCopyWithImpl(
    _$NotificationChannelImpl _value,
    $Res Function(_$NotificationChannelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _$NotificationChannelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$NotificationChannelImpl implements _NotificationChannel {
  const _$NotificationChannelImpl({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'NotificationChannel(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  /// Create a copy of NotificationChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationChannelImplCopyWith<_$NotificationChannelImpl> get copyWith =>
      __$$NotificationChannelImplCopyWithImpl<_$NotificationChannelImpl>(
        this,
        _$identity,
      );
}

abstract class _NotificationChannel implements NotificationChannel {
  const factory _NotificationChannel({
    required final String id,
    required final String name,
    final String? description,
  }) = _$NotificationChannelImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of NotificationChannel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationChannelImplCopyWith<_$NotificationChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
