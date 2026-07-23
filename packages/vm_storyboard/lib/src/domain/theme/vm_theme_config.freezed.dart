// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vm_theme_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VmThemeConfig {
  VmColorPalette? get palette => throw _privateConstructorUsedError;
  VmLogo? get logo => throw _privateConstructorUsedError;
  String? get fontFamily => throw _privateConstructorUsedError;

  /// Create a copy of VmThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VmThemeConfigCopyWith<VmThemeConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VmThemeConfigCopyWith<$Res> {
  factory $VmThemeConfigCopyWith(
    VmThemeConfig value,
    $Res Function(VmThemeConfig) then,
  ) = _$VmThemeConfigCopyWithImpl<$Res, VmThemeConfig>;
  @useResult
  $Res call({VmColorPalette? palette, VmLogo? logo, String? fontFamily});

  $VmColorPaletteCopyWith<$Res>? get palette;
  $VmLogoCopyWith<$Res>? get logo;
}

/// @nodoc
class _$VmThemeConfigCopyWithImpl<$Res, $Val extends VmThemeConfig>
    implements $VmThemeConfigCopyWith<$Res> {
  _$VmThemeConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VmThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? palette = freezed,
    Object? logo = freezed,
    Object? fontFamily = freezed,
  }) {
    return _then(
      _value.copyWith(
            palette: freezed == palette
                ? _value.palette
                : palette // ignore: cast_nullable_to_non_nullable
                      as VmColorPalette?,
            logo: freezed == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as VmLogo?,
            fontFamily: freezed == fontFamily
                ? _value.fontFamily
                : fontFamily // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of VmThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VmColorPaletteCopyWith<$Res>? get palette {
    if (_value.palette == null) {
      return null;
    }

    return $VmColorPaletteCopyWith<$Res>(_value.palette!, (value) {
      return _then(_value.copyWith(palette: value) as $Val);
    });
  }

  /// Create a copy of VmThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VmLogoCopyWith<$Res>? get logo {
    if (_value.logo == null) {
      return null;
    }

    return $VmLogoCopyWith<$Res>(_value.logo!, (value) {
      return _then(_value.copyWith(logo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VmThemeConfigImplCopyWith<$Res>
    implements $VmThemeConfigCopyWith<$Res> {
  factory _$$VmThemeConfigImplCopyWith(
    _$VmThemeConfigImpl value,
    $Res Function(_$VmThemeConfigImpl) then,
  ) = __$$VmThemeConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({VmColorPalette? palette, VmLogo? logo, String? fontFamily});

  @override
  $VmColorPaletteCopyWith<$Res>? get palette;
  @override
  $VmLogoCopyWith<$Res>? get logo;
}

/// @nodoc
class __$$VmThemeConfigImplCopyWithImpl<$Res>
    extends _$VmThemeConfigCopyWithImpl<$Res, _$VmThemeConfigImpl>
    implements _$$VmThemeConfigImplCopyWith<$Res> {
  __$$VmThemeConfigImplCopyWithImpl(
    _$VmThemeConfigImpl _value,
    $Res Function(_$VmThemeConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VmThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? palette = freezed,
    Object? logo = freezed,
    Object? fontFamily = freezed,
  }) {
    return _then(
      _$VmThemeConfigImpl(
        palette: freezed == palette
            ? _value.palette
            : palette // ignore: cast_nullable_to_non_nullable
                  as VmColorPalette?,
        logo: freezed == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as VmLogo?,
        fontFamily: freezed == fontFamily
            ? _value.fontFamily
            : fontFamily // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$VmThemeConfigImpl implements _VmThemeConfig {
  const _$VmThemeConfigImpl({
    required this.palette,
    required this.logo,
    this.fontFamily,
  });

  @override
  final VmColorPalette? palette;
  @override
  final VmLogo? logo;
  @override
  final String? fontFamily;

  @override
  String toString() {
    return 'VmThemeConfig(palette: $palette, logo: $logo, fontFamily: $fontFamily)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VmThemeConfigImpl &&
            (identical(other.palette, palette) || other.palette == palette) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily));
  }

  @override
  int get hashCode => Object.hash(runtimeType, palette, logo, fontFamily);

  /// Create a copy of VmThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VmThemeConfigImplCopyWith<_$VmThemeConfigImpl> get copyWith =>
      __$$VmThemeConfigImplCopyWithImpl<_$VmThemeConfigImpl>(this, _$identity);
}

abstract class _VmThemeConfig implements VmThemeConfig {
  const factory _VmThemeConfig({
    required final VmColorPalette? palette,
    required final VmLogo? logo,
    final String? fontFamily,
  }) = _$VmThemeConfigImpl;

  @override
  VmColorPalette? get palette;
  @override
  VmLogo? get logo;
  @override
  String? get fontFamily;

  /// Create a copy of VmThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VmThemeConfigImplCopyWith<_$VmThemeConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
