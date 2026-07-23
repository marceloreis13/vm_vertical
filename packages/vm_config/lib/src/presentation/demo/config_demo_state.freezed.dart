// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_demo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ConfigDemoField {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  Object? get defaultValue => throw _privateConstructorUsedError;
  Object? get cacheValue => throw _privateConstructorUsedError;
  Object? get remoteValue => throw _privateConstructorUsedError;
  Object? get resolvedValue => throw _privateConstructorUsedError;

  /// Create a copy of ConfigDemoField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigDemoFieldCopyWith<ConfigDemoField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigDemoFieldCopyWith<$Res> {
  factory $ConfigDemoFieldCopyWith(
    ConfigDemoField value,
    $Res Function(ConfigDemoField) then,
  ) = _$ConfigDemoFieldCopyWithImpl<$Res, ConfigDemoField>;
  @useResult
  $Res call({
    String key,
    String label,
    Object? defaultValue,
    Object? cacheValue,
    Object? remoteValue,
    Object? resolvedValue,
  });
}

/// @nodoc
class _$ConfigDemoFieldCopyWithImpl<$Res, $Val extends ConfigDemoField>
    implements $ConfigDemoFieldCopyWith<$Res> {
  _$ConfigDemoFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigDemoField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? defaultValue = freezed,
    Object? cacheValue = freezed,
    Object? remoteValue = freezed,
    Object? resolvedValue = freezed,
  }) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultValue: freezed == defaultValue
                ? _value.defaultValue
                : defaultValue,
            cacheValue: freezed == cacheValue ? _value.cacheValue : cacheValue,
            remoteValue: freezed == remoteValue
                ? _value.remoteValue
                : remoteValue,
            resolvedValue: freezed == resolvedValue
                ? _value.resolvedValue
                : resolvedValue,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfigDemoFieldImplCopyWith<$Res>
    implements $ConfigDemoFieldCopyWith<$Res> {
  factory _$$ConfigDemoFieldImplCopyWith(
    _$ConfigDemoFieldImpl value,
    $Res Function(_$ConfigDemoFieldImpl) then,
  ) = __$$ConfigDemoFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String key,
    String label,
    Object? defaultValue,
    Object? cacheValue,
    Object? remoteValue,
    Object? resolvedValue,
  });
}

/// @nodoc
class __$$ConfigDemoFieldImplCopyWithImpl<$Res>
    extends _$ConfigDemoFieldCopyWithImpl<$Res, _$ConfigDemoFieldImpl>
    implements _$$ConfigDemoFieldImplCopyWith<$Res> {
  __$$ConfigDemoFieldImplCopyWithImpl(
    _$ConfigDemoFieldImpl _value,
    $Res Function(_$ConfigDemoFieldImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfigDemoField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? defaultValue = freezed,
    Object? cacheValue = freezed,
    Object? remoteValue = freezed,
    Object? resolvedValue = freezed,
  }) {
    return _then(
      _$ConfigDemoFieldImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultValue: freezed == defaultValue
            ? _value.defaultValue
            : defaultValue,
        cacheValue: freezed == cacheValue ? _value.cacheValue : cacheValue,
        remoteValue: freezed == remoteValue ? _value.remoteValue : remoteValue,
        resolvedValue: freezed == resolvedValue
            ? _value.resolvedValue
            : resolvedValue,
      ),
    );
  }
}

/// @nodoc

class _$ConfigDemoFieldImpl implements _ConfigDemoField {
  const _$ConfigDemoFieldImpl({
    required this.key,
    required this.label,
    required this.defaultValue,
    required this.cacheValue,
    required this.remoteValue,
    required this.resolvedValue,
  });

  @override
  final String key;
  @override
  final String label;
  @override
  final Object? defaultValue;
  @override
  final Object? cacheValue;
  @override
  final Object? remoteValue;
  @override
  final Object? resolvedValue;

  @override
  String toString() {
    return 'ConfigDemoField(key: $key, label: $label, defaultValue: $defaultValue, cacheValue: $cacheValue, remoteValue: $remoteValue, resolvedValue: $resolvedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigDemoFieldImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(
              other.defaultValue,
              defaultValue,
            ) &&
            const DeepCollectionEquality().equals(
              other.cacheValue,
              cacheValue,
            ) &&
            const DeepCollectionEquality().equals(
              other.remoteValue,
              remoteValue,
            ) &&
            const DeepCollectionEquality().equals(
              other.resolvedValue,
              resolvedValue,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    key,
    label,
    const DeepCollectionEquality().hash(defaultValue),
    const DeepCollectionEquality().hash(cacheValue),
    const DeepCollectionEquality().hash(remoteValue),
    const DeepCollectionEquality().hash(resolvedValue),
  );

  /// Create a copy of ConfigDemoField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigDemoFieldImplCopyWith<_$ConfigDemoFieldImpl> get copyWith =>
      __$$ConfigDemoFieldImplCopyWithImpl<_$ConfigDemoFieldImpl>(
        this,
        _$identity,
      );
}

abstract class _ConfigDemoField implements ConfigDemoField {
  const factory _ConfigDemoField({
    required final String key,
    required final String label,
    required final Object? defaultValue,
    required final Object? cacheValue,
    required final Object? remoteValue,
    required final Object? resolvedValue,
  }) = _$ConfigDemoFieldImpl;

  @override
  String get key;
  @override
  String get label;
  @override
  Object? get defaultValue;
  @override
  Object? get cacheValue;
  @override
  Object? get remoteValue;
  @override
  Object? get resolvedValue;

  /// Create a copy of ConfigDemoField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigDemoFieldImplCopyWith<_$ConfigDemoFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConfigDemoState {
  List<ConfigDemoField> get fields => throw _privateConstructorUsedError;

  /// Create a copy of ConfigDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigDemoStateCopyWith<ConfigDemoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigDemoStateCopyWith<$Res> {
  factory $ConfigDemoStateCopyWith(
    ConfigDemoState value,
    $Res Function(ConfigDemoState) then,
  ) = _$ConfigDemoStateCopyWithImpl<$Res, ConfigDemoState>;
  @useResult
  $Res call({List<ConfigDemoField> fields});
}

/// @nodoc
class _$ConfigDemoStateCopyWithImpl<$Res, $Val extends ConfigDemoState>
    implements $ConfigDemoStateCopyWith<$Res> {
  _$ConfigDemoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fields = null}) {
    return _then(
      _value.copyWith(
            fields: null == fields
                ? _value.fields
                : fields // ignore: cast_nullable_to_non_nullable
                      as List<ConfigDemoField>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfigDemoStateImplCopyWith<$Res>
    implements $ConfigDemoStateCopyWith<$Res> {
  factory _$$ConfigDemoStateImplCopyWith(
    _$ConfigDemoStateImpl value,
    $Res Function(_$ConfigDemoStateImpl) then,
  ) = __$$ConfigDemoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ConfigDemoField> fields});
}

/// @nodoc
class __$$ConfigDemoStateImplCopyWithImpl<$Res>
    extends _$ConfigDemoStateCopyWithImpl<$Res, _$ConfigDemoStateImpl>
    implements _$$ConfigDemoStateImplCopyWith<$Res> {
  __$$ConfigDemoStateImplCopyWithImpl(
    _$ConfigDemoStateImpl _value,
    $Res Function(_$ConfigDemoStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfigDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fields = null}) {
    return _then(
      _$ConfigDemoStateImpl(
        fields: null == fields
            ? _value._fields
            : fields // ignore: cast_nullable_to_non_nullable
                  as List<ConfigDemoField>,
      ),
    );
  }
}

/// @nodoc

class _$ConfigDemoStateImpl implements _ConfigDemoState {
  const _$ConfigDemoStateImpl({required final List<ConfigDemoField> fields})
    : _fields = fields;

  final List<ConfigDemoField> _fields;
  @override
  List<ConfigDemoField> get fields {
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fields);
  }

  @override
  String toString() {
    return 'ConfigDemoState(fields: $fields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigDemoStateImpl &&
            const DeepCollectionEquality().equals(other._fields, _fields));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_fields));

  /// Create a copy of ConfigDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigDemoStateImplCopyWith<_$ConfigDemoStateImpl> get copyWith =>
      __$$ConfigDemoStateImplCopyWithImpl<_$ConfigDemoStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ConfigDemoState implements ConfigDemoState {
  const factory _ConfigDemoState({
    required final List<ConfigDemoField> fields,
  }) = _$ConfigDemoStateImpl;

  @override
  List<ConfigDemoField> get fields;

  /// Create a copy of ConfigDemoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigDemoStateImplCopyWith<_$ConfigDemoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
