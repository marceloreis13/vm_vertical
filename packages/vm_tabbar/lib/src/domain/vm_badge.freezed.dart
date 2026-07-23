// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vm_badge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VmBadge {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int value) count,
    required TResult Function() dot,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int value)? count,
    TResult? Function()? dot,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int value)? count,
    TResult Function()? dot,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VmBadgeCount value) count,
    required TResult Function(VmBadgeDot value) dot,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VmBadgeCount value)? count,
    TResult? Function(VmBadgeDot value)? dot,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VmBadgeCount value)? count,
    TResult Function(VmBadgeDot value)? dot,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VmBadgeCopyWith<$Res> {
  factory $VmBadgeCopyWith(VmBadge value, $Res Function(VmBadge) then) =
      _$VmBadgeCopyWithImpl<$Res, VmBadge>;
}

/// @nodoc
class _$VmBadgeCopyWithImpl<$Res, $Val extends VmBadge>
    implements $VmBadgeCopyWith<$Res> {
  _$VmBadgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VmBadge
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$VmBadgeCountImplCopyWith<$Res> {
  factory _$$VmBadgeCountImplCopyWith(
    _$VmBadgeCountImpl value,
    $Res Function(_$VmBadgeCountImpl) then,
  ) = __$$VmBadgeCountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$VmBadgeCountImplCopyWithImpl<$Res>
    extends _$VmBadgeCopyWithImpl<$Res, _$VmBadgeCountImpl>
    implements _$$VmBadgeCountImplCopyWith<$Res> {
  __$$VmBadgeCountImplCopyWithImpl(
    _$VmBadgeCountImpl _value,
    $Res Function(_$VmBadgeCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VmBadge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _$VmBadgeCountImpl(
        null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$VmBadgeCountImpl implements VmBadgeCount {
  const _$VmBadgeCountImpl(this.value);

  @override
  final int value;

  @override
  String toString() {
    return 'VmBadge.count(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VmBadgeCountImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of VmBadge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VmBadgeCountImplCopyWith<_$VmBadgeCountImpl> get copyWith =>
      __$$VmBadgeCountImplCopyWithImpl<_$VmBadgeCountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int value) count,
    required TResult Function() dot,
  }) {
    return count(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int value)? count,
    TResult? Function()? dot,
  }) {
    return count?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int value)? count,
    TResult Function()? dot,
    required TResult orElse(),
  }) {
    if (count != null) {
      return count(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VmBadgeCount value) count,
    required TResult Function(VmBadgeDot value) dot,
  }) {
    return count(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VmBadgeCount value)? count,
    TResult? Function(VmBadgeDot value)? dot,
  }) {
    return count?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VmBadgeCount value)? count,
    TResult Function(VmBadgeDot value)? dot,
    required TResult orElse(),
  }) {
    if (count != null) {
      return count(this);
    }
    return orElse();
  }
}

abstract class VmBadgeCount implements VmBadge {
  const factory VmBadgeCount(final int value) = _$VmBadgeCountImpl;

  int get value;

  /// Create a copy of VmBadge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VmBadgeCountImplCopyWith<_$VmBadgeCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VmBadgeDotImplCopyWith<$Res> {
  factory _$$VmBadgeDotImplCopyWith(
    _$VmBadgeDotImpl value,
    $Res Function(_$VmBadgeDotImpl) then,
  ) = __$$VmBadgeDotImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$VmBadgeDotImplCopyWithImpl<$Res>
    extends _$VmBadgeCopyWithImpl<$Res, _$VmBadgeDotImpl>
    implements _$$VmBadgeDotImplCopyWith<$Res> {
  __$$VmBadgeDotImplCopyWithImpl(
    _$VmBadgeDotImpl _value,
    $Res Function(_$VmBadgeDotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VmBadge
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$VmBadgeDotImpl implements VmBadgeDot {
  const _$VmBadgeDotImpl();

  @override
  String toString() {
    return 'VmBadge.dot()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$VmBadgeDotImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int value) count,
    required TResult Function() dot,
  }) {
    return dot();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int value)? count,
    TResult? Function()? dot,
  }) {
    return dot?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int value)? count,
    TResult Function()? dot,
    required TResult orElse(),
  }) {
    if (dot != null) {
      return dot();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VmBadgeCount value) count,
    required TResult Function(VmBadgeDot value) dot,
  }) {
    return dot(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VmBadgeCount value)? count,
    TResult? Function(VmBadgeDot value)? dot,
  }) {
    return dot?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VmBadgeCount value)? count,
    TResult Function(VmBadgeDot value)? dot,
    required TResult orElse(),
  }) {
    if (dot != null) {
      return dot(this);
    }
    return orElse();
  }
}

abstract class VmBadgeDot implements VmBadge {
  const factory VmBadgeDot() = _$VmBadgeDotImpl;
}
