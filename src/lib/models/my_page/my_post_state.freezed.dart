// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MyPostState _$MyPostStateFromJson(Map<String, dynamic> json) {
  return _MyPostState.fromJson(json);
}

/// @nodoc
mixin _$MyPostState {
  SelectPost get myPostState => throw _privateConstructorUsedError;
  SelectPost get myKeepState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MyPostStateCopyWith<MyPostState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyPostStateCopyWith<$Res> {
  factory $MyPostStateCopyWith(
          MyPostState value, $Res Function(MyPostState) then) =
      _$MyPostStateCopyWithImpl<$Res, MyPostState>;
  @useResult
  $Res call({SelectPost myPostState, SelectPost myKeepState});

  $SelectPostCopyWith<$Res> get myPostState;
  $SelectPostCopyWith<$Res> get myKeepState;
}

/// @nodoc
class _$MyPostStateCopyWithImpl<$Res, $Val extends MyPostState>
    implements $MyPostStateCopyWith<$Res> {
  _$MyPostStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myPostState = null,
    Object? myKeepState = null,
  }) {
    return _then(_value.copyWith(
      myPostState: null == myPostState
          ? _value.myPostState
          : myPostState // ignore: cast_nullable_to_non_nullable
              as SelectPost,
      myKeepState: null == myKeepState
          ? _value.myKeepState
          : myKeepState // ignore: cast_nullable_to_non_nullable
              as SelectPost,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SelectPostCopyWith<$Res> get myPostState {
    return $SelectPostCopyWith<$Res>(_value.myPostState, (value) {
      return _then(_value.copyWith(myPostState: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SelectPostCopyWith<$Res> get myKeepState {
    return $SelectPostCopyWith<$Res>(_value.myKeepState, (value) {
      return _then(_value.copyWith(myKeepState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MyPostStateCopyWith<$Res>
    implements $MyPostStateCopyWith<$Res> {
  factory _$$_MyPostStateCopyWith(
          _$_MyPostState value, $Res Function(_$_MyPostState) then) =
      __$$_MyPostStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SelectPost myPostState, SelectPost myKeepState});

  @override
  $SelectPostCopyWith<$Res> get myPostState;
  @override
  $SelectPostCopyWith<$Res> get myKeepState;
}

/// @nodoc
class __$$_MyPostStateCopyWithImpl<$Res>
    extends _$MyPostStateCopyWithImpl<$Res, _$_MyPostState>
    implements _$$_MyPostStateCopyWith<$Res> {
  __$$_MyPostStateCopyWithImpl(
      _$_MyPostState _value, $Res Function(_$_MyPostState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myPostState = null,
    Object? myKeepState = null,
  }) {
    return _then(_$_MyPostState(
      myPostState: null == myPostState
          ? _value.myPostState
          : myPostState // ignore: cast_nullable_to_non_nullable
              as SelectPost,
      myKeepState: null == myKeepState
          ? _value.myKeepState
          : myKeepState // ignore: cast_nullable_to_non_nullable
              as SelectPost,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MyPostState implements _MyPostState {
  _$_MyPostState({required this.myPostState, required this.myKeepState});

  factory _$_MyPostState.fromJson(Map<String, dynamic> json) =>
      _$$_MyPostStateFromJson(json);

  @override
  final SelectPost myPostState;
  @override
  final SelectPost myKeepState;

  @override
  String toString() {
    return 'MyPostState(myPostState: $myPostState, myKeepState: $myKeepState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MyPostState &&
            (identical(other.myPostState, myPostState) ||
                other.myPostState == myPostState) &&
            (identical(other.myKeepState, myKeepState) ||
                other.myKeepState == myKeepState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, myPostState, myKeepState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MyPostStateCopyWith<_$_MyPostState> get copyWith =>
      __$$_MyPostStateCopyWithImpl<_$_MyPostState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MyPostStateToJson(
      this,
    );
  }
}

abstract class _MyPostState implements MyPostState {
  factory _MyPostState(
      {required final SelectPost myPostState,
      required final SelectPost myKeepState}) = _$_MyPostState;

  factory _MyPostState.fromJson(Map<String, dynamic> json) =
      _$_MyPostState.fromJson;

  @override
  SelectPost get myPostState;
  @override
  SelectPost get myKeepState;
  @override
  @JsonKey(ignore: true)
  _$$_MyPostStateCopyWith<_$_MyPostState> get copyWith =>
      throw _privateConstructorUsedError;
}
