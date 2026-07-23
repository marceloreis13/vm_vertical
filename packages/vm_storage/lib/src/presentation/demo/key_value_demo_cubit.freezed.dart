// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'key_value_demo_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$KeyValueDemoState {
  Map<String, String> get entries => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of KeyValueDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeyValueDemoStateCopyWith<KeyValueDemoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeyValueDemoStateCopyWith<$Res> {
  factory $KeyValueDemoStateCopyWith(
    KeyValueDemoState value,
    $Res Function(KeyValueDemoState) then,
  ) = _$KeyValueDemoStateCopyWithImpl<$Res, KeyValueDemoState>;
  @useResult
  $Res call({Map<String, String> entries, String? errorMessage});
}

/// @nodoc
class _$KeyValueDemoStateCopyWithImpl<$Res, $Val extends KeyValueDemoState>
    implements $KeyValueDemoStateCopyWith<$Res> {
  _$KeyValueDemoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeyValueDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? entries = null, Object? errorMessage = freezed}) {
    return _then(
      _value.copyWith(
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeyValueDemoStateImplCopyWith<$Res>
    implements $KeyValueDemoStateCopyWith<$Res> {
  factory _$$KeyValueDemoStateImplCopyWith(
    _$KeyValueDemoStateImpl value,
    $Res Function(_$KeyValueDemoStateImpl) then,
  ) = __$$KeyValueDemoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, String> entries, String? errorMessage});
}

/// @nodoc
class __$$KeyValueDemoStateImplCopyWithImpl<$Res>
    extends _$KeyValueDemoStateCopyWithImpl<$Res, _$KeyValueDemoStateImpl>
    implements _$$KeyValueDemoStateImplCopyWith<$Res> {
  __$$KeyValueDemoStateImplCopyWithImpl(
    _$KeyValueDemoStateImpl _value,
    $Res Function(_$KeyValueDemoStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeyValueDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? entries = null, Object? errorMessage = freezed}) {
    return _then(
      _$KeyValueDemoStateImpl(
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$KeyValueDemoStateImpl implements _KeyValueDemoState {
  const _$KeyValueDemoStateImpl({
    final Map<String, String> entries = const {},
    this.errorMessage,
  }) : _entries = entries;

  final Map<String, String> _entries;
  @override
  @JsonKey()
  Map<String, String> get entries {
    if (_entries is EqualUnmodifiableMapView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_entries);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'KeyValueDemoState(entries: $entries, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeyValueDemoStateImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_entries),
    errorMessage,
  );

  /// Create a copy of KeyValueDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeyValueDemoStateImplCopyWith<_$KeyValueDemoStateImpl> get copyWith =>
      __$$KeyValueDemoStateImplCopyWithImpl<_$KeyValueDemoStateImpl>(
        this,
        _$identity,
      );
}

abstract class _KeyValueDemoState implements KeyValueDemoState {
  const factory _KeyValueDemoState({
    final Map<String, String> entries,
    final String? errorMessage,
  }) = _$KeyValueDemoStateImpl;

  @override
  Map<String, String> get entries;
  @override
  String? get errorMessage;

  /// Create a copy of KeyValueDemoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeyValueDemoStateImplCopyWith<_$KeyValueDemoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
