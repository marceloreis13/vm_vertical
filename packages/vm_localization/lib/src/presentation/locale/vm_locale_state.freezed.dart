// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vm_locale_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VmLocaleState {
  Locale get locale => throw _privateConstructorUsedError;
  List<Locale> get supportedLocales => throw _privateConstructorUsedError;

  /// Create a copy of VmLocaleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VmLocaleStateCopyWith<VmLocaleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VmLocaleStateCopyWith<$Res> {
  factory $VmLocaleStateCopyWith(
    VmLocaleState value,
    $Res Function(VmLocaleState) then,
  ) = _$VmLocaleStateCopyWithImpl<$Res, VmLocaleState>;
  @useResult
  $Res call({Locale locale, List<Locale> supportedLocales});
}

/// @nodoc
class _$VmLocaleStateCopyWithImpl<$Res, $Val extends VmLocaleState>
    implements $VmLocaleStateCopyWith<$Res> {
  _$VmLocaleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VmLocaleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locale = null, Object? supportedLocales = null}) {
    return _then(
      _value.copyWith(
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as Locale,
            supportedLocales: null == supportedLocales
                ? _value.supportedLocales
                : supportedLocales // ignore: cast_nullable_to_non_nullable
                      as List<Locale>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VmLocaleStateImplCopyWith<$Res>
    implements $VmLocaleStateCopyWith<$Res> {
  factory _$$VmLocaleStateImplCopyWith(
    _$VmLocaleStateImpl value,
    $Res Function(_$VmLocaleStateImpl) then,
  ) = __$$VmLocaleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Locale locale, List<Locale> supportedLocales});
}

/// @nodoc
class __$$VmLocaleStateImplCopyWithImpl<$Res>
    extends _$VmLocaleStateCopyWithImpl<$Res, _$VmLocaleStateImpl>
    implements _$$VmLocaleStateImplCopyWith<$Res> {
  __$$VmLocaleStateImplCopyWithImpl(
    _$VmLocaleStateImpl _value,
    $Res Function(_$VmLocaleStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VmLocaleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locale = null, Object? supportedLocales = null}) {
    return _then(
      _$VmLocaleStateImpl(
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as Locale,
        supportedLocales: null == supportedLocales
            ? _value._supportedLocales
            : supportedLocales // ignore: cast_nullable_to_non_nullable
                  as List<Locale>,
      ),
    );
  }
}

/// @nodoc

class _$VmLocaleStateImpl implements _VmLocaleState {
  const _$VmLocaleStateImpl({
    required this.locale,
    required final List<Locale> supportedLocales,
  }) : _supportedLocales = supportedLocales;

  @override
  final Locale locale;
  final List<Locale> _supportedLocales;
  @override
  List<Locale> get supportedLocales {
    if (_supportedLocales is EqualUnmodifiableListView)
      return _supportedLocales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedLocales);
  }

  @override
  String toString() {
    return 'VmLocaleState(locale: $locale, supportedLocales: $supportedLocales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VmLocaleStateImpl &&
            (identical(other.locale, locale) || other.locale == locale) &&
            const DeepCollectionEquality().equals(
              other._supportedLocales,
              _supportedLocales,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    locale,
    const DeepCollectionEquality().hash(_supportedLocales),
  );

  /// Create a copy of VmLocaleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VmLocaleStateImplCopyWith<_$VmLocaleStateImpl> get copyWith =>
      __$$VmLocaleStateImplCopyWithImpl<_$VmLocaleStateImpl>(this, _$identity);
}

abstract class _VmLocaleState implements VmLocaleState {
  const factory _VmLocaleState({
    required final Locale locale,
    required final List<Locale> supportedLocales,
  }) = _$VmLocaleStateImpl;

  @override
  Locale get locale;
  @override
  List<Locale> get supportedLocales;

  /// Create a copy of VmLocaleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VmLocaleStateImplCopyWith<_$VmLocaleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
