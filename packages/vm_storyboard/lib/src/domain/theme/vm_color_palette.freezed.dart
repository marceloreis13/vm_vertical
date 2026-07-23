// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vm_color_palette.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VmColorPalette {
  Color get primary => throw _privateConstructorUsedError;
  Color get secondary => throw _privateConstructorUsedError;
  Color get tertiary => throw _privateConstructorUsedError;
  Color get error => throw _privateConstructorUsedError;

  /// Create a copy of VmColorPalette
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VmColorPaletteCopyWith<VmColorPalette> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VmColorPaletteCopyWith<$Res> {
  factory $VmColorPaletteCopyWith(
    VmColorPalette value,
    $Res Function(VmColorPalette) then,
  ) = _$VmColorPaletteCopyWithImpl<$Res, VmColorPalette>;
  @useResult
  $Res call({Color primary, Color secondary, Color tertiary, Color error});
}

/// @nodoc
class _$VmColorPaletteCopyWithImpl<$Res, $Val extends VmColorPalette>
    implements $VmColorPaletteCopyWith<$Res> {
  _$VmColorPaletteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VmColorPalette
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? secondary = null,
    Object? tertiary = null,
    Object? error = null,
  }) {
    return _then(
      _value.copyWith(
            primary: null == primary
                ? _value.primary
                : primary // ignore: cast_nullable_to_non_nullable
                      as Color,
            secondary: null == secondary
                ? _value.secondary
                : secondary // ignore: cast_nullable_to_non_nullable
                      as Color,
            tertiary: null == tertiary
                ? _value.tertiary
                : tertiary // ignore: cast_nullable_to_non_nullable
                      as Color,
            error: null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as Color,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VmColorPaletteImplCopyWith<$Res>
    implements $VmColorPaletteCopyWith<$Res> {
  factory _$$VmColorPaletteImplCopyWith(
    _$VmColorPaletteImpl value,
    $Res Function(_$VmColorPaletteImpl) then,
  ) = __$$VmColorPaletteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Color primary, Color secondary, Color tertiary, Color error});
}

/// @nodoc
class __$$VmColorPaletteImplCopyWithImpl<$Res>
    extends _$VmColorPaletteCopyWithImpl<$Res, _$VmColorPaletteImpl>
    implements _$$VmColorPaletteImplCopyWith<$Res> {
  __$$VmColorPaletteImplCopyWithImpl(
    _$VmColorPaletteImpl _value,
    $Res Function(_$VmColorPaletteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VmColorPalette
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? secondary = null,
    Object? tertiary = null,
    Object? error = null,
  }) {
    return _then(
      _$VmColorPaletteImpl(
        primary: null == primary
            ? _value.primary
            : primary // ignore: cast_nullable_to_non_nullable
                  as Color,
        secondary: null == secondary
            ? _value.secondary
            : secondary // ignore: cast_nullable_to_non_nullable
                  as Color,
        tertiary: null == tertiary
            ? _value.tertiary
            : tertiary // ignore: cast_nullable_to_non_nullable
                  as Color,
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as Color,
      ),
    );
  }
}

/// @nodoc

class _$VmColorPaletteImpl implements _VmColorPalette {
  const _$VmColorPaletteImpl({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
  });

  @override
  final Color primary;
  @override
  final Color secondary;
  @override
  final Color tertiary;
  @override
  final Color error;

  @override
  String toString() {
    return 'VmColorPalette(primary: $primary, secondary: $secondary, tertiary: $tertiary, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VmColorPaletteImpl &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.secondary, secondary) ||
                other.secondary == secondary) &&
            (identical(other.tertiary, tertiary) ||
                other.tertiary == tertiary) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, primary, secondary, tertiary, error);

  /// Create a copy of VmColorPalette
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VmColorPaletteImplCopyWith<_$VmColorPaletteImpl> get copyWith =>
      __$$VmColorPaletteImplCopyWithImpl<_$VmColorPaletteImpl>(
        this,
        _$identity,
      );
}

abstract class _VmColorPalette implements VmColorPalette {
  const factory _VmColorPalette({
    required final Color primary,
    required final Color secondary,
    required final Color tertiary,
    required final Color error,
  }) = _$VmColorPaletteImpl;

  @override
  Color get primary;
  @override
  Color get secondary;
  @override
  Color get tertiary;
  @override
  Color get error;

  /// Create a copy of VmColorPalette
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VmColorPaletteImplCopyWith<_$VmColorPaletteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
