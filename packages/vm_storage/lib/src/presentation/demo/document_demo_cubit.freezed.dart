// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_demo_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DocumentDemoState {
  List<DemoNote> get notes => throw _privateConstructorUsedError;
  bool get softDeleteEnabled => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of DocumentDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentDemoStateCopyWith<DocumentDemoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentDemoStateCopyWith<$Res> {
  factory $DocumentDemoStateCopyWith(
    DocumentDemoState value,
    $Res Function(DocumentDemoState) then,
  ) = _$DocumentDemoStateCopyWithImpl<$Res, DocumentDemoState>;
  @useResult
  $Res call({
    List<DemoNote> notes,
    bool softDeleteEnabled,
    String? errorMessage,
  });
}

/// @nodoc
class _$DocumentDemoStateCopyWithImpl<$Res, $Val extends DocumentDemoState>
    implements $DocumentDemoStateCopyWith<$Res> {
  _$DocumentDemoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = null,
    Object? softDeleteEnabled = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as List<DemoNote>,
            softDeleteEnabled: null == softDeleteEnabled
                ? _value.softDeleteEnabled
                : softDeleteEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$DocumentDemoStateImplCopyWith<$Res>
    implements $DocumentDemoStateCopyWith<$Res> {
  factory _$$DocumentDemoStateImplCopyWith(
    _$DocumentDemoStateImpl value,
    $Res Function(_$DocumentDemoStateImpl) then,
  ) = __$$DocumentDemoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DemoNote> notes,
    bool softDeleteEnabled,
    String? errorMessage,
  });
}

/// @nodoc
class __$$DocumentDemoStateImplCopyWithImpl<$Res>
    extends _$DocumentDemoStateCopyWithImpl<$Res, _$DocumentDemoStateImpl>
    implements _$$DocumentDemoStateImplCopyWith<$Res> {
  __$$DocumentDemoStateImplCopyWithImpl(
    _$DocumentDemoStateImpl _value,
    $Res Function(_$DocumentDemoStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentDemoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = null,
    Object? softDeleteEnabled = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$DocumentDemoStateImpl(
        notes: null == notes
            ? _value._notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as List<DemoNote>,
        softDeleteEnabled: null == softDeleteEnabled
            ? _value.softDeleteEnabled
            : softDeleteEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DocumentDemoStateImpl implements _DocumentDemoState {
  const _$DocumentDemoStateImpl({
    final List<DemoNote> notes = const [],
    this.softDeleteEnabled = false,
    this.errorMessage,
  }) : _notes = notes;

  final List<DemoNote> _notes;
  @override
  @JsonKey()
  List<DemoNote> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  @JsonKey()
  final bool softDeleteEnabled;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DocumentDemoState(notes: $notes, softDeleteEnabled: $softDeleteEnabled, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentDemoStateImpl &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.softDeleteEnabled, softDeleteEnabled) ||
                other.softDeleteEnabled == softDeleteEnabled) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_notes),
    softDeleteEnabled,
    errorMessage,
  );

  /// Create a copy of DocumentDemoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentDemoStateImplCopyWith<_$DocumentDemoStateImpl> get copyWith =>
      __$$DocumentDemoStateImplCopyWithImpl<_$DocumentDemoStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DocumentDemoState implements DocumentDemoState {
  const factory _DocumentDemoState({
    final List<DemoNote> notes,
    final bool softDeleteEnabled,
    final String? errorMessage,
  }) = _$DocumentDemoStateImpl;

  @override
  List<DemoNote> get notes;
  @override
  bool get softDeleteEnabled;
  @override
  String? get errorMessage;

  /// Create a copy of DocumentDemoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentDemoStateImplCopyWith<_$DocumentDemoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
