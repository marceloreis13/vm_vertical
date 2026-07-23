// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'secure_demo_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SecureDemoState {
  String? get token => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of SecureDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SecureDemoStateCopyWith<SecureDemoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecureDemoStateCopyWith<$Res> {
  factory $SecureDemoStateCopyWith(
    SecureDemoState value,
    $Res Function(SecureDemoState) then,
  ) = _$SecureDemoStateCopyWithImpl<$Res, SecureDemoState>;
  @useResult
  $Res call({String? token, String? errorMessage});
}

/// @nodoc
class _$SecureDemoStateCopyWithImpl<$Res, $Val extends SecureDemoState>
    implements $SecureDemoStateCopyWith<$Res> {
  _$SecureDemoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecureDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = freezed, Object? errorMessage = freezed}) {
    return _then(
      _value.copyWith(
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$SecureDemoStateImplCopyWith<$Res>
    implements $SecureDemoStateCopyWith<$Res> {
  factory _$$SecureDemoStateImplCopyWith(
    _$SecureDemoStateImpl value,
    $Res Function(_$SecureDemoStateImpl) then,
  ) = __$$SecureDemoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? token, String? errorMessage});
}

/// @nodoc
class __$$SecureDemoStateImplCopyWithImpl<$Res>
    extends _$SecureDemoStateCopyWithImpl<$Res, _$SecureDemoStateImpl>
    implements _$$SecureDemoStateImplCopyWith<$Res> {
  __$$SecureDemoStateImplCopyWithImpl(
    _$SecureDemoStateImpl _value,
    $Res Function(_$SecureDemoStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecureDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = freezed, Object? errorMessage = freezed}) {
    return _then(
      _$SecureDemoStateImpl(
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SecureDemoStateImpl implements _SecureDemoState {
  const _$SecureDemoStateImpl({this.token, this.errorMessage});

  @override
  final String? token;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SecureDemoState(token: $token, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecureDemoStateImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, errorMessage);

  /// Create a copy of SecureDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SecureDemoStateImplCopyWith<_$SecureDemoStateImpl> get copyWith =>
      __$$SecureDemoStateImplCopyWithImpl<_$SecureDemoStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SecureDemoState implements SecureDemoState {
  const factory _SecureDemoState({
    final String? token,
    final String? errorMessage,
  }) = _$SecureDemoStateImpl;

  @override
  String? get token;
  @override
  String? get errorMessage;

  /// Create a copy of SecureDemoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SecureDemoStateImplCopyWith<_$SecureDemoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
