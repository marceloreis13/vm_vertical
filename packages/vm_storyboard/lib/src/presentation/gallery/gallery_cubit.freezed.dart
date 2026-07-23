// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GalleryState {
  Set<String> get selectedChips => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  bool get showBanner => throw _privateConstructorUsedError;

  /// Create a copy of GalleryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GalleryStateCopyWith<GalleryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryStateCopyWith<$Res> {
  factory $GalleryStateCopyWith(
    GalleryState value,
    $Res Function(GalleryState) then,
  ) = _$GalleryStateCopyWithImpl<$Res, GalleryState>;
  @useResult
  $Res call({Set<String> selectedChips, String unit, bool showBanner});
}

/// @nodoc
class _$GalleryStateCopyWithImpl<$Res, $Val extends GalleryState>
    implements $GalleryStateCopyWith<$Res> {
  _$GalleryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GalleryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedChips = null,
    Object? unit = null,
    Object? showBanner = null,
  }) {
    return _then(
      _value.copyWith(
            selectedChips: null == selectedChips
                ? _value.selectedChips
                : selectedChips // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            showBanner: null == showBanner
                ? _value.showBanner
                : showBanner // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GalleryStateImplCopyWith<$Res>
    implements $GalleryStateCopyWith<$Res> {
  factory _$$GalleryStateImplCopyWith(
    _$GalleryStateImpl value,
    $Res Function(_$GalleryStateImpl) then,
  ) = __$$GalleryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<String> selectedChips, String unit, bool showBanner});
}

/// @nodoc
class __$$GalleryStateImplCopyWithImpl<$Res>
    extends _$GalleryStateCopyWithImpl<$Res, _$GalleryStateImpl>
    implements _$$GalleryStateImplCopyWith<$Res> {
  __$$GalleryStateImplCopyWithImpl(
    _$GalleryStateImpl _value,
    $Res Function(_$GalleryStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GalleryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedChips = null,
    Object? unit = null,
    Object? showBanner = null,
  }) {
    return _then(
      _$GalleryStateImpl(
        selectedChips: null == selectedChips
            ? _value._selectedChips
            : selectedChips // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        showBanner: null == showBanner
            ? _value.showBanner
            : showBanner // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GalleryStateImpl implements _GalleryState {
  const _$GalleryStateImpl({
    final Set<String> selectedChips = const {'Featured'},
    this.unit = 'C',
    this.showBanner = true,
  }) : _selectedChips = selectedChips;

  final Set<String> _selectedChips;
  @override
  @JsonKey()
  Set<String> get selectedChips {
    if (_selectedChips is EqualUnmodifiableSetView) return _selectedChips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedChips);
  }

  @override
  @JsonKey()
  final String unit;
  @override
  @JsonKey()
  final bool showBanner;

  @override
  String toString() {
    return 'GalleryState(selectedChips: $selectedChips, unit: $unit, showBanner: $showBanner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GalleryStateImpl &&
            const DeepCollectionEquality().equals(
              other._selectedChips,
              _selectedChips,
            ) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.showBanner, showBanner) ||
                other.showBanner == showBanner));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_selectedChips),
    unit,
    showBanner,
  );

  /// Create a copy of GalleryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryStateImplCopyWith<_$GalleryStateImpl> get copyWith =>
      __$$GalleryStateImplCopyWithImpl<_$GalleryStateImpl>(this, _$identity);
}

abstract class _GalleryState implements GalleryState {
  const factory _GalleryState({
    final Set<String> selectedChips,
    final String unit,
    final bool showBanner,
  }) = _$GalleryStateImpl;

  @override
  Set<String> get selectedChips;
  @override
  String get unit;
  @override
  bool get showBanner;

  /// Create a copy of GalleryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GalleryStateImplCopyWith<_$GalleryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
