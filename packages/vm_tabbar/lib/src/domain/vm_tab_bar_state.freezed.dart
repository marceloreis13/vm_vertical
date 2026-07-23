// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vm_tab_bar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VmTabBarState {
  int get index => throw _privateConstructorUsedError;
  Map<int, VmBadge?> get badges => throw _privateConstructorUsedError;

  /// Create a copy of VmTabBarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VmTabBarStateCopyWith<VmTabBarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VmTabBarStateCopyWith<$Res> {
  factory $VmTabBarStateCopyWith(
    VmTabBarState value,
    $Res Function(VmTabBarState) then,
  ) = _$VmTabBarStateCopyWithImpl<$Res, VmTabBarState>;
  @useResult
  $Res call({int index, Map<int, VmBadge?> badges});
}

/// @nodoc
class _$VmTabBarStateCopyWithImpl<$Res, $Val extends VmTabBarState>
    implements $VmTabBarStateCopyWith<$Res> {
  _$VmTabBarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VmTabBarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? index = null, Object? badges = null}) {
    return _then(
      _value.copyWith(
            index: null == index
                ? _value.index
                : index // ignore: cast_nullable_to_non_nullable
                      as int,
            badges: null == badges
                ? _value.badges
                : badges // ignore: cast_nullable_to_non_nullable
                      as Map<int, VmBadge?>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VmTabBarStateImplCopyWith<$Res>
    implements $VmTabBarStateCopyWith<$Res> {
  factory _$$VmTabBarStateImplCopyWith(
    _$VmTabBarStateImpl value,
    $Res Function(_$VmTabBarStateImpl) then,
  ) = __$$VmTabBarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, Map<int, VmBadge?> badges});
}

/// @nodoc
class __$$VmTabBarStateImplCopyWithImpl<$Res>
    extends _$VmTabBarStateCopyWithImpl<$Res, _$VmTabBarStateImpl>
    implements _$$VmTabBarStateImplCopyWith<$Res> {
  __$$VmTabBarStateImplCopyWithImpl(
    _$VmTabBarStateImpl _value,
    $Res Function(_$VmTabBarStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VmTabBarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? index = null, Object? badges = null}) {
    return _then(
      _$VmTabBarStateImpl(
        index: null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        badges: null == badges
            ? _value._badges
            : badges // ignore: cast_nullable_to_non_nullable
                  as Map<int, VmBadge?>,
      ),
    );
  }
}

/// @nodoc

class _$VmTabBarStateImpl implements _VmTabBarState {
  const _$VmTabBarStateImpl({
    required this.index,
    required final Map<int, VmBadge?> badges,
  }) : _badges = badges;

  @override
  final int index;
  final Map<int, VmBadge?> _badges;
  @override
  Map<int, VmBadge?> get badges {
    if (_badges is EqualUnmodifiableMapView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_badges);
  }

  @override
  String toString() {
    return 'VmTabBarState(index: $index, badges: $badges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VmTabBarStateImpl &&
            (identical(other.index, index) || other.index == index) &&
            const DeepCollectionEquality().equals(other._badges, _badges));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    index,
    const DeepCollectionEquality().hash(_badges),
  );

  /// Create a copy of VmTabBarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VmTabBarStateImplCopyWith<_$VmTabBarStateImpl> get copyWith =>
      __$$VmTabBarStateImplCopyWithImpl<_$VmTabBarStateImpl>(this, _$identity);
}

abstract class _VmTabBarState implements VmTabBarState {
  const factory _VmTabBarState({
    required final int index,
    required final Map<int, VmBadge?> badges,
  }) = _$VmTabBarStateImpl;

  @override
  int get index;
  @override
  Map<int, VmBadge?> get badges;

  /// Create a copy of VmTabBarState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VmTabBarStateImplCopyWith<_$VmTabBarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
