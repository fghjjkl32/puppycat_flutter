// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FollowState _$FollowStateFromJson(Map<String, dynamic> json) {
  return _FollowState.fromJson(json);
}

/// @nodoc
mixin _$FollowState {
  FollowDataListModel get followerListState =>
      throw _privateConstructorUsedError;
  FollowDataListModel get followListState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FollowStateCopyWith<FollowState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowStateCopyWith<$Res> {
  factory $FollowStateCopyWith(
          FollowState value, $Res Function(FollowState) then) =
      _$FollowStateCopyWithImpl<$Res, FollowState>;
  @useResult
  $Res call(
      {FollowDataListModel followerListState,
      FollowDataListModel followListState});

  $FollowDataListModelCopyWith<$Res> get followerListState;
  $FollowDataListModelCopyWith<$Res> get followListState;
}

/// @nodoc
class _$FollowStateCopyWithImpl<$Res, $Val extends FollowState>
    implements $FollowStateCopyWith<$Res> {
  _$FollowStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followerListState = null,
    Object? followListState = null,
  }) {
    return _then(_value.copyWith(
      followerListState: null == followerListState
          ? _value.followerListState
          : followerListState // ignore: cast_nullable_to_non_nullable
              as FollowDataListModel,
      followListState: null == followListState
          ? _value.followListState
          : followListState // ignore: cast_nullable_to_non_nullable
              as FollowDataListModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FollowDataListModelCopyWith<$Res> get followerListState {
    return $FollowDataListModelCopyWith<$Res>(_value.followerListState,
        (value) {
      return _then(_value.copyWith(followerListState: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FollowDataListModelCopyWith<$Res> get followListState {
    return $FollowDataListModelCopyWith<$Res>(_value.followListState, (value) {
      return _then(_value.copyWith(followListState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FollowStateCopyWith<$Res>
    implements $FollowStateCopyWith<$Res> {
  factory _$$_FollowStateCopyWith(
          _$_FollowState value, $Res Function(_$_FollowState) then) =
      __$$_FollowStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FollowDataListModel followerListState,
      FollowDataListModel followListState});

  @override
  $FollowDataListModelCopyWith<$Res> get followerListState;
  @override
  $FollowDataListModelCopyWith<$Res> get followListState;
}

/// @nodoc
class __$$_FollowStateCopyWithImpl<$Res>
    extends _$FollowStateCopyWithImpl<$Res, _$_FollowState>
    implements _$$_FollowStateCopyWith<$Res> {
  __$$_FollowStateCopyWithImpl(
      _$_FollowState _value, $Res Function(_$_FollowState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followerListState = null,
    Object? followListState = null,
  }) {
    return _then(_$_FollowState(
      followerListState: null == followerListState
          ? _value.followerListState
          : followerListState // ignore: cast_nullable_to_non_nullable
              as FollowDataListModel,
      followListState: null == followListState
          ? _value.followListState
          : followListState // ignore: cast_nullable_to_non_nullable
              as FollowDataListModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FollowState implements _FollowState {
  _$_FollowState(
      {required this.followerListState, required this.followListState});

  factory _$_FollowState.fromJson(Map<String, dynamic> json) =>
      _$$_FollowStateFromJson(json);

  @override
  final FollowDataListModel followerListState;
  @override
  final FollowDataListModel followListState;

  @override
  String toString() {
    return 'FollowState(followerListState: $followerListState, followListState: $followListState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FollowState &&
            (identical(other.followerListState, followerListState) ||
                other.followerListState == followerListState) &&
            (identical(other.followListState, followListState) ||
                other.followListState == followListState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, followerListState, followListState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FollowStateCopyWith<_$_FollowState> get copyWith =>
      __$$_FollowStateCopyWithImpl<_$_FollowState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FollowStateToJson(
      this,
    );
  }
}

abstract class _FollowState implements FollowState {
  factory _FollowState(
      {required final FollowDataListModel followerListState,
      required final FollowDataListModel followListState}) = _$_FollowState;

  factory _FollowState.fromJson(Map<String, dynamic> json) =
      _$_FollowState.fromJson;

  @override
  FollowDataListModel get followerListState;
  @override
  FollowDataListModel get followListState;
  @override
  @JsonKey(ignore: true)
  _$$_FollowStateCopyWith<_$_FollowState> get copyWith =>
      throw _privateConstructorUsedError;
}
