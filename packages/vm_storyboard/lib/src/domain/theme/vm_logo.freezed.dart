// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vm_logo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VmLogo {
  WidgetBuilder get builder => throw _privateConstructorUsedError;

  /// Create a copy of VmLogo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VmLogoCopyWith<VmLogo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VmLogoCopyWith<$Res> {
  factory $VmLogoCopyWith(VmLogo value, $Res Function(VmLogo) then) =
      _$VmLogoCopyWithImpl<$Res, VmLogo>;
  @useResult
  $Res call({WidgetBuilder builder});
}

/// @nodoc
class _$VmLogoCopyWithImpl<$Res, $Val extends VmLogo>
    implements $VmLogoCopyWith<$Res> {
  _$VmLogoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VmLogo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? builder = null}) {
    return _then(
      _value.copyWith(
            builder: null == builder
                ? _value.builder
                : builder // ignore: cast_nullable_to_non_nullable
                      as WidgetBuilder,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VmLogoImplCopyWith<$Res> implements $VmLogoCopyWith<$Res> {
  factory _$$VmLogoImplCopyWith(
    _$VmLogoImpl value,
    $Res Function(_$VmLogoImpl) then,
  ) = __$$VmLogoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WidgetBuilder builder});
}

/// @nodoc
class __$$VmLogoImplCopyWithImpl<$Res>
    extends _$VmLogoCopyWithImpl<$Res, _$VmLogoImpl>
    implements _$$VmLogoImplCopyWith<$Res> {
  __$$VmLogoImplCopyWithImpl(
    _$VmLogoImpl _value,
    $Res Function(_$VmLogoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VmLogo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? builder = null}) {
    return _then(
      _$VmLogoImpl(
        builder: null == builder
            ? _value.builder
            : builder // ignore: cast_nullable_to_non_nullable
                  as WidgetBuilder,
      ),
    );
  }
}

/// @nodoc

class _$VmLogoImpl implements _VmLogo {
  const _$VmLogoImpl({required this.builder});

  @override
  final WidgetBuilder builder;

  @override
  String toString() {
    return 'VmLogo(builder: $builder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VmLogoImpl &&
            (identical(other.builder, builder) || other.builder == builder));
  }

  @override
  int get hashCode => Object.hash(runtimeType, builder);

  /// Create a copy of VmLogo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VmLogoImplCopyWith<_$VmLogoImpl> get copyWith =>
      __$$VmLogoImplCopyWithImpl<_$VmLogoImpl>(this, _$identity);
}

abstract class _VmLogo implements VmLogo {
  const factory _VmLogo({required final WidgetBuilder builder}) = _$VmLogoImpl;

  @override
  WidgetBuilder get builder;

  /// Create a copy of VmLogo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VmLogoImplCopyWith<_$VmLogoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
