// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_header_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommentHeaderState _$CommentHeaderStateFromJson(Map<String, dynamic> json) {
  return _CommentHeaderState.fromJson(json);
}

/// @nodoc
mixin _$CommentHeaderState {
  bool get isReply => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get parentIdx => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentHeaderStateCopyWith<CommentHeaderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentHeaderStateCopyWith<$Res> {
  factory $CommentHeaderStateCopyWith(
          CommentHeaderState value, $Res Function(CommentHeaderState) then) =
      _$CommentHeaderStateCopyWithImpl<$Res, CommentHeaderState>;
  @useResult
  $Res call({bool isReply, String name, int? parentIdx});
}

/// @nodoc
class _$CommentHeaderStateCopyWithImpl<$Res, $Val extends CommentHeaderState>
    implements $CommentHeaderStateCopyWith<$Res> {
  _$CommentHeaderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReply = null,
    Object? name = null,
    Object? parentIdx = freezed,
  }) {
    return _then(_value.copyWith(
      isReply: null == isReply
          ? _value.isReply
          : isReply // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentIdx: freezed == parentIdx
          ? _value.parentIdx
          : parentIdx // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CommentHeaderStateCopyWith<$Res>
    implements $CommentHeaderStateCopyWith<$Res> {
  factory _$$_CommentHeaderStateCopyWith(_$_CommentHeaderState value,
          $Res Function(_$_CommentHeaderState) then) =
      __$$_CommentHeaderStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isReply, String name, int? parentIdx});
}

/// @nodoc
class __$$_CommentHeaderStateCopyWithImpl<$Res>
    extends _$CommentHeaderStateCopyWithImpl<$Res, _$_CommentHeaderState>
    implements _$$_CommentHeaderStateCopyWith<$Res> {
  __$$_CommentHeaderStateCopyWithImpl(
      _$_CommentHeaderState _value, $Res Function(_$_CommentHeaderState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReply = null,
    Object? name = null,
    Object? parentIdx = freezed,
  }) {
    return _then(_$_CommentHeaderState(
      isReply: null == isReply
          ? _value.isReply
          : isReply // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentIdx: freezed == parentIdx
          ? _value.parentIdx
          : parentIdx // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CommentHeaderState implements _CommentHeaderState {
  _$_CommentHeaderState(
      {this.isReply = false, this.name = "", this.parentIdx = null});

  factory _$_CommentHeaderState.fromJson(Map<String, dynamic> json) =>
      _$$_CommentHeaderStateFromJson(json);

  @override
  @JsonKey()
  final bool isReply;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int? parentIdx;

  @override
  String toString() {
    return 'CommentHeaderState(isReply: $isReply, name: $name, parentIdx: $parentIdx)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CommentHeaderState &&
            (identical(other.isReply, isReply) || other.isReply == isReply) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentIdx, parentIdx) ||
                other.parentIdx == parentIdx));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isReply, name, parentIdx);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CommentHeaderStateCopyWith<_$_CommentHeaderState> get copyWith =>
      __$$_CommentHeaderStateCopyWithImpl<_$_CommentHeaderState>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentHeaderStateToJson(
      this,
    );
  }
}

abstract class _CommentHeaderState implements CommentHeaderState {
  factory _CommentHeaderState(
      {final bool isReply,
      final String name,
      final int? parentIdx}) = _$_CommentHeaderState;

  factory _CommentHeaderState.fromJson(Map<String, dynamic> json) =
      _$_CommentHeaderState.fromJson;

  @override
  bool get isReply;
  @override
  String get name;
  @override
  int? get parentIdx;
  @override
  @JsonKey(ignore: true)
  _$$_CommentHeaderStateCopyWith<_$_CommentHeaderState> get copyWith =>
      throw _privateConstructorUsedError;
}
