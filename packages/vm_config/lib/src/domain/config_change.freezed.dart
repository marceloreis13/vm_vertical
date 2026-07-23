// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ConfigChange {
  Set<String> get keys => throw _privateConstructorUsedError;

  /// Create a copy of ConfigChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigChangeCopyWith<ConfigChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigChangeCopyWith<$Res> {
  factory $ConfigChangeCopyWith(
    ConfigChange value,
    $Res Function(ConfigChange) then,
  ) = _$ConfigChangeCopyWithImpl<$Res, ConfigChange>;
  @useResult
  $Res call({Set<String> keys});
}

/// @nodoc
class _$ConfigChangeCopyWithImpl<$Res, $Val extends ConfigChange>
    implements $ConfigChangeCopyWith<$Res> {
  _$ConfigChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? keys = null}) {
    return _then(
      _value.copyWith(
            keys: null == keys
                ? _value.keys
                : keys // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfigChangeImplCopyWith<$Res>
    implements $ConfigChangeCopyWith<$Res> {
  factory _$$ConfigChangeImplCopyWith(
    _$ConfigChangeImpl value,
    $Res Function(_$ConfigChangeImpl) then,
  ) = __$$ConfigChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<String> keys});
}

/// @nodoc
class __$$ConfigChangeImplCopyWithImpl<$Res>
    extends _$ConfigChangeCopyWithImpl<$Res, _$ConfigChangeImpl>
    implements _$$ConfigChangeImplCopyWith<$Res> {
  __$$ConfigChangeImplCopyWithImpl(
    _$ConfigChangeImpl _value,
    $Res Function(_$ConfigChangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfigChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? keys = null}) {
    return _then(
      _$ConfigChangeImpl(
        keys: null == keys
            ? _value._keys
            : keys // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
      ),
    );
  }
}

/// @nodoc

class _$ConfigChangeImpl implements _ConfigChange {
  const _$ConfigChangeImpl({required final Set<String> keys}) : _keys = keys;

  final Set<String> _keys;
  @override
  Set<String> get keys {
    if (_keys is EqualUnmodifiableSetView) return _keys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_keys);
  }

  @override
  String toString() {
    return 'ConfigChange(keys: $keys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigChangeImpl &&
            const DeepCollectionEquality().equals(other._keys, _keys));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_keys));

  /// Create a copy of ConfigChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigChangeImplCopyWith<_$ConfigChangeImpl> get copyWith =>
      __$$ConfigChangeImplCopyWithImpl<_$ConfigChangeImpl>(this, _$identity);
}

abstract class _ConfigChange implements ConfigChange {
  const factory _ConfigChange({required final Set<String> keys}) =
      _$ConfigChangeImpl;

  @override
  Set<String> get keys;

  /// Create a copy of ConfigChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigChangeImplCopyWith<_$ConfigChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
