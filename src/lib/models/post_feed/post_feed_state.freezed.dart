// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PostFeedState _$PostFeedStateFromJson(Map<String, dynamic> json) {
  return _PostFeedState.fromJson(json);
}

/// @nodoc
mixin _$PostFeedState {
  List<Offset> get tagList => throw _privateConstructorUsedError;
  List<TagImages> get tagImage => throw _privateConstructorUsedError;
  int get offsetCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostFeedStateCopyWith<PostFeedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostFeedStateCopyWith<$Res> {
  factory $PostFeedStateCopyWith(
          PostFeedState value, $Res Function(PostFeedState) then) =
      _$PostFeedStateCopyWithImpl<$Res, PostFeedState>;
  @useResult
  $Res call({List<Offset> tagList, List<TagImages> tagImage, int offsetCount});
}

/// @nodoc
class _$PostFeedStateCopyWithImpl<$Res, $Val extends PostFeedState>
    implements $PostFeedStateCopyWith<$Res> {
  _$PostFeedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagList = null,
    Object? tagImage = null,
    Object? offsetCount = null,
  }) {
    return _then(_value.copyWith(
      tagList: null == tagList
          ? _value.tagList
          : tagList // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      tagImage: null == tagImage
          ? _value.tagImage
          : tagImage // ignore: cast_nullable_to_non_nullable
              as List<TagImages>,
      offsetCount: null == offsetCount
          ? _value.offsetCount
          : offsetCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PostFeedStateCopyWith<$Res>
    implements $PostFeedStateCopyWith<$Res> {
  factory _$$_PostFeedStateCopyWith(
          _$_PostFeedState value, $Res Function(_$_PostFeedState) then) =
      __$$_PostFeedStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Offset> tagList, List<TagImages> tagImage, int offsetCount});
}

/// @nodoc
class __$$_PostFeedStateCopyWithImpl<$Res>
    extends _$PostFeedStateCopyWithImpl<$Res, _$_PostFeedState>
    implements _$$_PostFeedStateCopyWith<$Res> {
  __$$_PostFeedStateCopyWithImpl(
      _$_PostFeedState _value, $Res Function(_$_PostFeedState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagList = null,
    Object? tagImage = null,
    Object? offsetCount = null,
  }) {
    return _then(_$_PostFeedState(
      tagList: null == tagList
          ? _value._tagList
          : tagList // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      tagImage: null == tagImage
          ? _value._tagImage
          : tagImage // ignore: cast_nullable_to_non_nullable
              as List<TagImages>,
      offsetCount: null == offsetCount
          ? _value.offsetCount
          : offsetCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@OffsetConverter()
class _$_PostFeedState implements _PostFeedState {
  _$_PostFeedState(
      {final List<Offset> tagList = const [],
      final List<TagImages> tagImage = const [],
      this.offsetCount = 0})
      : _tagList = tagList,
        _tagImage = tagImage;

  factory _$_PostFeedState.fromJson(Map<String, dynamic> json) =>
      _$$_PostFeedStateFromJson(json);

  final List<Offset> _tagList;
  @override
  @JsonKey()
  List<Offset> get tagList {
    if (_tagList is EqualUnmodifiableListView) return _tagList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagList);
  }

  final List<TagImages> _tagImage;
  @override
  @JsonKey()
  List<TagImages> get tagImage {
    if (_tagImage is EqualUnmodifiableListView) return _tagImage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagImage);
  }

  @override
  @JsonKey()
  final int offsetCount;

  @override
  String toString() {
    return 'PostFeedState(tagList: $tagList, tagImage: $tagImage, offsetCount: $offsetCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PostFeedState &&
            const DeepCollectionEquality().equals(other._tagList, _tagList) &&
            const DeepCollectionEquality().equals(other._tagImage, _tagImage) &&
            (identical(other.offsetCount, offsetCount) ||
                other.offsetCount == offsetCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tagList),
      const DeepCollectionEquality().hash(_tagImage),
      offsetCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PostFeedStateCopyWith<_$_PostFeedState> get copyWith =>
      __$$_PostFeedStateCopyWithImpl<_$_PostFeedState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PostFeedStateToJson(
      this,
    );
  }
}

abstract class _PostFeedState implements PostFeedState {
  factory _PostFeedState(
      {final List<Offset> tagList,
      final List<TagImages> tagImage,
      final int offsetCount}) = _$_PostFeedState;

  factory _PostFeedState.fromJson(Map<String, dynamic> json) =
      _$_PostFeedState.fromJson;

  @override
  List<Offset> get tagList;
  @override
  List<TagImages> get tagImage;
  @override
  int get offsetCount;
  @override
  @JsonKey(ignore: true)
  _$$_PostFeedStateCopyWith<_$_PostFeedState> get copyWith =>
      throw _privateConstructorUsedError;
}
