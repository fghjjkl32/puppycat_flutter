// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedDetailState _$FeedDetailStateFromJson(Map<String, dynamic> json) {
  return _FeedDetailState.fromJson(json);
}

/// @nodoc
mixin _$FeedDetailState {
  FeedDataListModel get firstFeedState => throw _privateConstructorUsedError;
  FeedDataListModel get feedListState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedDetailStateCopyWith<FeedDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedDetailStateCopyWith<$Res> {
  factory $FeedDetailStateCopyWith(
          FeedDetailState value, $Res Function(FeedDetailState) then) =
      _$FeedDetailStateCopyWithImpl<$Res, FeedDetailState>;
  @useResult
  $Res call(
      {FeedDataListModel firstFeedState, FeedDataListModel feedListState});

  $FeedDataListModelCopyWith<$Res> get firstFeedState;
  $FeedDataListModelCopyWith<$Res> get feedListState;
}

/// @nodoc
class _$FeedDetailStateCopyWithImpl<$Res, $Val extends FeedDetailState>
    implements $FeedDetailStateCopyWith<$Res> {
  _$FeedDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstFeedState = null,
    Object? feedListState = null,
  }) {
    return _then(_value.copyWith(
      firstFeedState: null == firstFeedState
          ? _value.firstFeedState
          : firstFeedState // ignore: cast_nullable_to_non_nullable
              as FeedDataListModel,
      feedListState: null == feedListState
          ? _value.feedListState
          : feedListState // ignore: cast_nullable_to_non_nullable
              as FeedDataListModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FeedDataListModelCopyWith<$Res> get firstFeedState {
    return $FeedDataListModelCopyWith<$Res>(_value.firstFeedState, (value) {
      return _then(_value.copyWith(firstFeedState: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FeedDataListModelCopyWith<$Res> get feedListState {
    return $FeedDataListModelCopyWith<$Res>(_value.feedListState, (value) {
      return _then(_value.copyWith(feedListState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FeedDetailStateCopyWith<$Res>
    implements $FeedDetailStateCopyWith<$Res> {
  factory _$$_FeedDetailStateCopyWith(
          _$_FeedDetailState value, $Res Function(_$_FeedDetailState) then) =
      __$$_FeedDetailStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FeedDataListModel firstFeedState, FeedDataListModel feedListState});

  @override
  $FeedDataListModelCopyWith<$Res> get firstFeedState;
  @override
  $FeedDataListModelCopyWith<$Res> get feedListState;
}

/// @nodoc
class __$$_FeedDetailStateCopyWithImpl<$Res>
    extends _$FeedDetailStateCopyWithImpl<$Res, _$_FeedDetailState>
    implements _$$_FeedDetailStateCopyWith<$Res> {
  __$$_FeedDetailStateCopyWithImpl(
      _$_FeedDetailState _value, $Res Function(_$_FeedDetailState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstFeedState = null,
    Object? feedListState = null,
  }) {
    return _then(_$_FeedDetailState(
      firstFeedState: null == firstFeedState
          ? _value.firstFeedState
          : firstFeedState // ignore: cast_nullable_to_non_nullable
              as FeedDataListModel,
      feedListState: null == feedListState
          ? _value.feedListState
          : feedListState // ignore: cast_nullable_to_non_nullable
              as FeedDataListModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedDetailState implements _FeedDetailState {
  _$_FeedDetailState(
      {required this.firstFeedState, required this.feedListState});

  factory _$_FeedDetailState.fromJson(Map<String, dynamic> json) =>
      _$$_FeedDetailStateFromJson(json);

  @override
  final FeedDataListModel firstFeedState;
  @override
  final FeedDataListModel feedListState;

  @override
  String toString() {
    return 'FeedDetailState(firstFeedState: $firstFeedState, feedListState: $feedListState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedDetailState &&
            (identical(other.firstFeedState, firstFeedState) ||
                other.firstFeedState == firstFeedState) &&
            (identical(other.feedListState, feedListState) ||
                other.feedListState == feedListState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstFeedState, feedListState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedDetailStateCopyWith<_$_FeedDetailState> get copyWith =>
      __$$_FeedDetailStateCopyWithImpl<_$_FeedDetailState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedDetailStateToJson(
      this,
    );
  }
}

abstract class _FeedDetailState implements FeedDetailState {
  factory _FeedDetailState(
      {required final FeedDataListModel firstFeedState,
      required final FeedDataListModel feedListState}) = _$_FeedDetailState;

  factory _FeedDetailState.fromJson(Map<String, dynamic> json) =
      _$_FeedDetailState.fromJson;

  @override
  FeedDataListModel get firstFeedState;
  @override
  FeedDataListModel get feedListState;
  @override
  @JsonKey(ignore: true)
  _$$_FeedDetailStateCopyWith<_$_FeedDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}
