// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedData _$FeedDataFromJson(Map<String, dynamic> json) {
  return _FeedData.fromJson(json);
}

/// @nodoc
mixin _$FeedData {
  List<FeedCommentData>? get commentList => throw _privateConstructorUsedError;
  int? get followState => throw _privateConstructorUsedError;
  int? get isComment => throw _privateConstructorUsedError;
  int? get memberIdx => throw _privateConstructorUsedError;
  int? get isLike => throw _privateConstructorUsedError;
  int? get saveState => throw _privateConstructorUsedError;
  int? get isView => throw _privateConstructorUsedError;
  String? get regDate => throw _privateConstructorUsedError;
  int? get likeState => throw _privateConstructorUsedError;
  int? get imageCnt => throw _privateConstructorUsedError;
  String? get uuid => throw _privateConstructorUsedError;
  int? get likeCnt => throw _privateConstructorUsedError;
  String? get contents => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  int? get modifyState => throw _privateConstructorUsedError;
  int get idx => throw _privateConstructorUsedError;
  List<FeedMentionListData>? get mentionList =>
      throw _privateConstructorUsedError;
  int? get commentCnt => throw _privateConstructorUsedError;
  List<FeedHashTagListData>? get hashTagList =>
      throw _privateConstructorUsedError;
  List<FeedImgListData>? get imgList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedDataCopyWith<FeedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedDataCopyWith<$Res> {
  factory $FeedDataCopyWith(FeedData value, $Res Function(FeedData) then) =
      _$FeedDataCopyWithImpl<$Res, FeedData>;
  @useResult
  $Res call(
      {List<FeedCommentData>? commentList,
      int? followState,
      int? isComment,
      int? memberIdx,
      int? isLike,
      int? saveState,
      int? isView,
      String? regDate,
      int? likeState,
      int? imageCnt,
      String? uuid,
      int? likeCnt,
      String? contents,
      String? location,
      int? modifyState,
      int idx,
      List<FeedMentionListData>? mentionList,
      int? commentCnt,
      List<FeedHashTagListData>? hashTagList,
      List<FeedImgListData>? imgList});
}

/// @nodoc
class _$FeedDataCopyWithImpl<$Res, $Val extends FeedData>
    implements $FeedDataCopyWith<$Res> {
  _$FeedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentList = freezed,
    Object? followState = freezed,
    Object? isComment = freezed,
    Object? memberIdx = freezed,
    Object? isLike = freezed,
    Object? saveState = freezed,
    Object? isView = freezed,
    Object? regDate = freezed,
    Object? likeState = freezed,
    Object? imageCnt = freezed,
    Object? uuid = freezed,
    Object? likeCnt = freezed,
    Object? contents = freezed,
    Object? location = freezed,
    Object? modifyState = freezed,
    Object? idx = null,
    Object? mentionList = freezed,
    Object? commentCnt = freezed,
    Object? hashTagList = freezed,
    Object? imgList = freezed,
  }) {
    return _then(_value.copyWith(
      commentList: freezed == commentList
          ? _value.commentList
          : commentList // ignore: cast_nullable_to_non_nullable
              as List<FeedCommentData>?,
      followState: freezed == followState
          ? _value.followState
          : followState // ignore: cast_nullable_to_non_nullable
              as int?,
      isComment: freezed == isComment
          ? _value.isComment
          : isComment // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      isLike: freezed == isLike
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as int?,
      saveState: freezed == saveState
          ? _value.saveState
          : saveState // ignore: cast_nullable_to_non_nullable
              as int?,
      isView: freezed == isView
          ? _value.isView
          : isView // ignore: cast_nullable_to_non_nullable
              as int?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      likeState: freezed == likeState
          ? _value.likeState
          : likeState // ignore: cast_nullable_to_non_nullable
              as int?,
      imageCnt: freezed == imageCnt
          ? _value.imageCnt
          : imageCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCnt: freezed == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      contents: freezed == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      modifyState: freezed == modifyState
          ? _value.modifyState
          : modifyState // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      mentionList: freezed == mentionList
          ? _value.mentionList
          : mentionList // ignore: cast_nullable_to_non_nullable
              as List<FeedMentionListData>?,
      commentCnt: freezed == commentCnt
          ? _value.commentCnt
          : commentCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      hashTagList: freezed == hashTagList
          ? _value.hashTagList
          : hashTagList // ignore: cast_nullable_to_non_nullable
              as List<FeedHashTagListData>?,
      imgList: freezed == imgList
          ? _value.imgList
          : imgList // ignore: cast_nullable_to_non_nullable
              as List<FeedImgListData>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FeedDataCopyWith<$Res> implements $FeedDataCopyWith<$Res> {
  factory _$$_FeedDataCopyWith(
          _$_FeedData value, $Res Function(_$_FeedData) then) =
      __$$_FeedDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FeedCommentData>? commentList,
      int? followState,
      int? isComment,
      int? memberIdx,
      int? isLike,
      int? saveState,
      int? isView,
      String? regDate,
      int? likeState,
      int? imageCnt,
      String? uuid,
      int? likeCnt,
      String? contents,
      String? location,
      int? modifyState,
      int idx,
      List<FeedMentionListData>? mentionList,
      int? commentCnt,
      List<FeedHashTagListData>? hashTagList,
      List<FeedImgListData>? imgList});
}

/// @nodoc
class __$$_FeedDataCopyWithImpl<$Res>
    extends _$FeedDataCopyWithImpl<$Res, _$_FeedData>
    implements _$$_FeedDataCopyWith<$Res> {
  __$$_FeedDataCopyWithImpl(
      _$_FeedData _value, $Res Function(_$_FeedData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentList = freezed,
    Object? followState = freezed,
    Object? isComment = freezed,
    Object? memberIdx = freezed,
    Object? isLike = freezed,
    Object? saveState = freezed,
    Object? isView = freezed,
    Object? regDate = freezed,
    Object? likeState = freezed,
    Object? imageCnt = freezed,
    Object? uuid = freezed,
    Object? likeCnt = freezed,
    Object? contents = freezed,
    Object? location = freezed,
    Object? modifyState = freezed,
    Object? idx = null,
    Object? mentionList = freezed,
    Object? commentCnt = freezed,
    Object? hashTagList = freezed,
    Object? imgList = freezed,
  }) {
    return _then(_$_FeedData(
      commentList: freezed == commentList
          ? _value._commentList
          : commentList // ignore: cast_nullable_to_non_nullable
              as List<FeedCommentData>?,
      followState: freezed == followState
          ? _value.followState
          : followState // ignore: cast_nullable_to_non_nullable
              as int?,
      isComment: freezed == isComment
          ? _value.isComment
          : isComment // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      isLike: freezed == isLike
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as int?,
      saveState: freezed == saveState
          ? _value.saveState
          : saveState // ignore: cast_nullable_to_non_nullable
              as int?,
      isView: freezed == isView
          ? _value.isView
          : isView // ignore: cast_nullable_to_non_nullable
              as int?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      likeState: freezed == likeState
          ? _value.likeState
          : likeState // ignore: cast_nullable_to_non_nullable
              as int?,
      imageCnt: freezed == imageCnt
          ? _value.imageCnt
          : imageCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCnt: freezed == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      contents: freezed == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      modifyState: freezed == modifyState
          ? _value.modifyState
          : modifyState // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      mentionList: freezed == mentionList
          ? _value._mentionList
          : mentionList // ignore: cast_nullable_to_non_nullable
              as List<FeedMentionListData>?,
      commentCnt: freezed == commentCnt
          ? _value.commentCnt
          : commentCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      hashTagList: freezed == hashTagList
          ? _value._hashTagList
          : hashTagList // ignore: cast_nullable_to_non_nullable
              as List<FeedHashTagListData>?,
      imgList: freezed == imgList
          ? _value._imgList
          : imgList // ignore: cast_nullable_to_non_nullable
              as List<FeedImgListData>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedData implements _FeedData {
  _$_FeedData(
      {final List<FeedCommentData>? commentList,
      this.followState,
      this.isComment,
      this.memberIdx,
      this.isLike,
      this.saveState,
      this.isView,
      this.regDate,
      this.likeState,
      this.imageCnt,
      this.uuid,
      this.likeCnt,
      this.contents,
      this.location,
      this.modifyState,
      required this.idx,
      final List<FeedMentionListData>? mentionList,
      this.commentCnt,
      final List<FeedHashTagListData>? hashTagList,
      final List<FeedImgListData>? imgList})
      : _commentList = commentList,
        _mentionList = mentionList,
        _hashTagList = hashTagList,
        _imgList = imgList;

  factory _$_FeedData.fromJson(Map<String, dynamic> json) =>
      _$$_FeedDataFromJson(json);

  final List<FeedCommentData>? _commentList;
  @override
  List<FeedCommentData>? get commentList {
    final value = _commentList;
    if (value == null) return null;
    if (_commentList is EqualUnmodifiableListView) return _commentList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? followState;
  @override
  final int? isComment;
  @override
  final int? memberIdx;
  @override
  final int? isLike;
  @override
  final int? saveState;
  @override
  final int? isView;
  @override
  final String? regDate;
  @override
  final int? likeState;
  @override
  final int? imageCnt;
  @override
  final String? uuid;
  @override
  final int? likeCnt;
  @override
  final String? contents;
  @override
  final String? location;
  @override
  final int? modifyState;
  @override
  final int idx;
  final List<FeedMentionListData>? _mentionList;
  @override
  List<FeedMentionListData>? get mentionList {
    final value = _mentionList;
    if (value == null) return null;
    if (_mentionList is EqualUnmodifiableListView) return _mentionList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? commentCnt;
  final List<FeedHashTagListData>? _hashTagList;
  @override
  List<FeedHashTagListData>? get hashTagList {
    final value = _hashTagList;
    if (value == null) return null;
    if (_hashTagList is EqualUnmodifiableListView) return _hashTagList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<FeedImgListData>? _imgList;
  @override
  List<FeedImgListData>? get imgList {
    final value = _imgList;
    if (value == null) return null;
    if (_imgList is EqualUnmodifiableListView) return _imgList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FeedData(commentList: $commentList, followState: $followState, isComment: $isComment, memberIdx: $memberIdx, isLike: $isLike, saveState: $saveState, isView: $isView, regDate: $regDate, likeState: $likeState, imageCnt: $imageCnt, uuid: $uuid, likeCnt: $likeCnt, contents: $contents, location: $location, modifyState: $modifyState, idx: $idx, mentionList: $mentionList, commentCnt: $commentCnt, hashTagList: $hashTagList, imgList: $imgList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedData &&
            const DeepCollectionEquality()
                .equals(other._commentList, _commentList) &&
            (identical(other.followState, followState) ||
                other.followState == followState) &&
            (identical(other.isComment, isComment) ||
                other.isComment == isComment) &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.isLike, isLike) || other.isLike == isLike) &&
            (identical(other.saveState, saveState) ||
                other.saveState == saveState) &&
            (identical(other.isView, isView) || other.isView == isView) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.likeState, likeState) ||
                other.likeState == likeState) &&
            (identical(other.imageCnt, imageCnt) ||
                other.imageCnt == imageCnt) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.likeCnt, likeCnt) || other.likeCnt == likeCnt) &&
            (identical(other.contents, contents) ||
                other.contents == contents) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.modifyState, modifyState) ||
                other.modifyState == modifyState) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            const DeepCollectionEquality()
                .equals(other._mentionList, _mentionList) &&
            (identical(other.commentCnt, commentCnt) ||
                other.commentCnt == commentCnt) &&
            const DeepCollectionEquality()
                .equals(other._hashTagList, _hashTagList) &&
            const DeepCollectionEquality().equals(other._imgList, _imgList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_commentList),
        followState,
        isComment,
        memberIdx,
        isLike,
        saveState,
        isView,
        regDate,
        likeState,
        imageCnt,
        uuid,
        likeCnt,
        contents,
        location,
        modifyState,
        idx,
        const DeepCollectionEquality().hash(_mentionList),
        commentCnt,
        const DeepCollectionEquality().hash(_hashTagList),
        const DeepCollectionEquality().hash(_imgList)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedDataCopyWith<_$_FeedData> get copyWith =>
      __$$_FeedDataCopyWithImpl<_$_FeedData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedDataToJson(
      this,
    );
  }
}

abstract class _FeedData implements FeedData {
  factory _FeedData(
      {final List<FeedCommentData>? commentList,
      final int? followState,
      final int? isComment,
      final int? memberIdx,
      final int? isLike,
      final int? saveState,
      final int? isView,
      final String? regDate,
      final int? likeState,
      final int? imageCnt,
      final String? uuid,
      final int? likeCnt,
      final String? contents,
      final String? location,
      final int? modifyState,
      required final int idx,
      final List<FeedMentionListData>? mentionList,
      final int? commentCnt,
      final List<FeedHashTagListData>? hashTagList,
      final List<FeedImgListData>? imgList}) = _$_FeedData;

  factory _FeedData.fromJson(Map<String, dynamic> json) = _$_FeedData.fromJson;

  @override
  List<FeedCommentData>? get commentList;
  @override
  int? get followState;
  @override
  int? get isComment;
  @override
  int? get memberIdx;
  @override
  int? get isLike;
  @override
  int? get saveState;
  @override
  int? get isView;
  @override
  String? get regDate;
  @override
  int? get likeState;
  @override
  int? get imageCnt;
  @override
  String? get uuid;
  @override
  int? get likeCnt;
  @override
  String? get contents;
  @override
  String? get location;
  @override
  int? get modifyState;
  @override
  int get idx;
  @override
  List<FeedMentionListData>? get mentionList;
  @override
  int? get commentCnt;
  @override
  List<FeedHashTagListData>? get hashTagList;
  @override
  List<FeedImgListData>? get imgList;
  @override
  @JsonKey(ignore: true)
  _$$_FeedDataCopyWith<_$_FeedData> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedCommentData _$FeedCommentDataFromJson(Map<String, dynamic> json) {
  return _FeedCommentData.fromJson(json);
}

/// @nodoc
mixin _$FeedCommentData {
  String? get nick => throw _privateConstructorUsedError;
  int? get likeCnt => throw _privateConstructorUsedError;
  int? get isBadge => throw _privateConstructorUsedError;
  int? get memberIdx => throw _privateConstructorUsedError;
  String? get contents => throw _privateConstructorUsedError;
  String? get regDate => throw _privateConstructorUsedError;
  int? get likeState => throw _privateConstructorUsedError;
  int? get idx => throw _privateConstructorUsedError;
  String? get profileImgUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedCommentDataCopyWith<FeedCommentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedCommentDataCopyWith<$Res> {
  factory $FeedCommentDataCopyWith(
          FeedCommentData value, $Res Function(FeedCommentData) then) =
      _$FeedCommentDataCopyWithImpl<$Res, FeedCommentData>;
  @useResult
  $Res call(
      {String? nick,
      int? likeCnt,
      int? isBadge,
      int? memberIdx,
      String? contents,
      String? regDate,
      int? likeState,
      int? idx,
      String? profileImgUrl});
}

/// @nodoc
class _$FeedCommentDataCopyWithImpl<$Res, $Val extends FeedCommentData>
    implements $FeedCommentDataCopyWith<$Res> {
  _$FeedCommentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = freezed,
    Object? likeCnt = freezed,
    Object? isBadge = freezed,
    Object? memberIdx = freezed,
    Object? contents = freezed,
    Object? regDate = freezed,
    Object? likeState = freezed,
    Object? idx = freezed,
    Object? profileImgUrl = freezed,
  }) {
    return _then(_value.copyWith(
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCnt: freezed == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      contents: freezed == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      likeState: freezed == likeState
          ? _value.likeState
          : likeState // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FeedCommentDataCopyWith<$Res>
    implements $FeedCommentDataCopyWith<$Res> {
  factory _$$_FeedCommentDataCopyWith(
          _$_FeedCommentData value, $Res Function(_$_FeedCommentData) then) =
      __$$_FeedCommentDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? nick,
      int? likeCnt,
      int? isBadge,
      int? memberIdx,
      String? contents,
      String? regDate,
      int? likeState,
      int? idx,
      String? profileImgUrl});
}

/// @nodoc
class __$$_FeedCommentDataCopyWithImpl<$Res>
    extends _$FeedCommentDataCopyWithImpl<$Res, _$_FeedCommentData>
    implements _$$_FeedCommentDataCopyWith<$Res> {
  __$$_FeedCommentDataCopyWithImpl(
      _$_FeedCommentData _value, $Res Function(_$_FeedCommentData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = freezed,
    Object? likeCnt = freezed,
    Object? isBadge = freezed,
    Object? memberIdx = freezed,
    Object? contents = freezed,
    Object? regDate = freezed,
    Object? likeState = freezed,
    Object? idx = freezed,
    Object? profileImgUrl = freezed,
  }) {
    return _then(_$_FeedCommentData(
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCnt: freezed == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      contents: freezed == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      likeState: freezed == likeState
          ? _value.likeState
          : likeState // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedCommentData implements _FeedCommentData {
  _$_FeedCommentData(
      {this.nick,
      this.likeCnt,
      this.isBadge,
      this.memberIdx,
      this.contents,
      this.regDate,
      this.likeState,
      this.idx,
      this.profileImgUrl});

  factory _$_FeedCommentData.fromJson(Map<String, dynamic> json) =>
      _$$_FeedCommentDataFromJson(json);

  @override
  final String? nick;
  @override
  final int? likeCnt;
  @override
  final int? isBadge;
  @override
  final int? memberIdx;
  @override
  final String? contents;
  @override
  final String? regDate;
  @override
  final int? likeState;
  @override
  final int? idx;
  @override
  final String? profileImgUrl;

  @override
  String toString() {
    return 'FeedCommentData(nick: $nick, likeCnt: $likeCnt, isBadge: $isBadge, memberIdx: $memberIdx, contents: $contents, regDate: $regDate, likeState: $likeState, idx: $idx, profileImgUrl: $profileImgUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedCommentData &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.likeCnt, likeCnt) || other.likeCnt == likeCnt) &&
            (identical(other.isBadge, isBadge) || other.isBadge == isBadge) &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.contents, contents) ||
                other.contents == contents) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.likeState, likeState) ||
                other.likeState == likeState) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.profileImgUrl, profileImgUrl) ||
                other.profileImgUrl == profileImgUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, nick, likeCnt, isBadge,
      memberIdx, contents, regDate, likeState, idx, profileImgUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedCommentDataCopyWith<_$_FeedCommentData> get copyWith =>
      __$$_FeedCommentDataCopyWithImpl<_$_FeedCommentData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedCommentDataToJson(
      this,
    );
  }
}

abstract class _FeedCommentData implements FeedCommentData {
  factory _FeedCommentData(
      {final String? nick,
      final int? likeCnt,
      final int? isBadge,
      final int? memberIdx,
      final String? contents,
      final String? regDate,
      final int? likeState,
      final int? idx,
      final String? profileImgUrl}) = _$_FeedCommentData;

  factory _FeedCommentData.fromJson(Map<String, dynamic> json) =
      _$_FeedCommentData.fromJson;

  @override
  String? get nick;
  @override
  int? get likeCnt;
  @override
  int? get isBadge;
  @override
  int? get memberIdx;
  @override
  String? get contents;
  @override
  String? get regDate;
  @override
  int? get likeState;
  @override
  int? get idx;
  @override
  String? get profileImgUrl;
  @override
  @JsonKey(ignore: true)
  _$$_FeedCommentDataCopyWith<_$_FeedCommentData> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedMemberInfoListData _$FeedMemberInfoListDataFromJson(
    Map<String, dynamic> json) {
  return _FeedMemberInfoListData.fromJson(json);
}

/// @nodoc
mixin _$FeedMemberInfoListData {
  String? get nick => throw _privateConstructorUsedError;
  String? get simpleType => throw _privateConstructorUsedError;
  int? get isBadge => throw _privateConstructorUsedError;
  int? get memberIdx => throw _privateConstructorUsedError;
  int? get followerCnt => throw _privateConstructorUsedError;
  String? get profileImgUrl => throw _privateConstructorUsedError;
  String? get intro => throw _privateConstructorUsedError;
  int? get followCnt => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedMemberInfoListDataCopyWith<FeedMemberInfoListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedMemberInfoListDataCopyWith<$Res> {
  factory $FeedMemberInfoListDataCopyWith(FeedMemberInfoListData value,
          $Res Function(FeedMemberInfoListData) then) =
      _$FeedMemberInfoListDataCopyWithImpl<$Res, FeedMemberInfoListData>;
  @useResult
  $Res call(
      {String? nick,
      String? simpleType,
      int? isBadge,
      int? memberIdx,
      int? followerCnt,
      String? profileImgUrl,
      String? intro,
      int? followCnt,
      String? email});
}

/// @nodoc
class _$FeedMemberInfoListDataCopyWithImpl<$Res,
        $Val extends FeedMemberInfoListData>
    implements $FeedMemberInfoListDataCopyWith<$Res> {
  _$FeedMemberInfoListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = freezed,
    Object? simpleType = freezed,
    Object? isBadge = freezed,
    Object? memberIdx = freezed,
    Object? followerCnt = freezed,
    Object? profileImgUrl = freezed,
    Object? intro = freezed,
    Object? followCnt = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
      simpleType: freezed == simpleType
          ? _value.simpleType
          : simpleType // ignore: cast_nullable_to_non_nullable
              as String?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      followerCnt: freezed == followerCnt
          ? _value.followerCnt
          : followerCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      intro: freezed == intro
          ? _value.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String?,
      followCnt: freezed == followCnt
          ? _value.followCnt
          : followCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FeedMemberInfoListDataCopyWith<$Res>
    implements $FeedMemberInfoListDataCopyWith<$Res> {
  factory _$$_FeedMemberInfoListDataCopyWith(_$_FeedMemberInfoListData value,
          $Res Function(_$_FeedMemberInfoListData) then) =
      __$$_FeedMemberInfoListDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? nick,
      String? simpleType,
      int? isBadge,
      int? memberIdx,
      int? followerCnt,
      String? profileImgUrl,
      String? intro,
      int? followCnt,
      String? email});
}

/// @nodoc
class __$$_FeedMemberInfoListDataCopyWithImpl<$Res>
    extends _$FeedMemberInfoListDataCopyWithImpl<$Res,
        _$_FeedMemberInfoListData>
    implements _$$_FeedMemberInfoListDataCopyWith<$Res> {
  __$$_FeedMemberInfoListDataCopyWithImpl(_$_FeedMemberInfoListData _value,
      $Res Function(_$_FeedMemberInfoListData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = freezed,
    Object? simpleType = freezed,
    Object? isBadge = freezed,
    Object? memberIdx = freezed,
    Object? followerCnt = freezed,
    Object? profileImgUrl = freezed,
    Object? intro = freezed,
    Object? followCnt = freezed,
    Object? email = freezed,
  }) {
    return _then(_$_FeedMemberInfoListData(
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
      simpleType: freezed == simpleType
          ? _value.simpleType
          : simpleType // ignore: cast_nullable_to_non_nullable
              as String?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      followerCnt: freezed == followerCnt
          ? _value.followerCnt
          : followerCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      intro: freezed == intro
          ? _value.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String?,
      followCnt: freezed == followCnt
          ? _value.followCnt
          : followCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedMemberInfoListData implements _FeedMemberInfoListData {
  _$_FeedMemberInfoListData(
      {this.nick,
      this.simpleType,
      this.isBadge,
      this.memberIdx,
      this.followerCnt,
      this.profileImgUrl,
      this.intro,
      this.followCnt,
      this.email});

  factory _$_FeedMemberInfoListData.fromJson(Map<String, dynamic> json) =>
      _$$_FeedMemberInfoListDataFromJson(json);

  @override
  final String? nick;
  @override
  final String? simpleType;
  @override
  final int? isBadge;
  @override
  final int? memberIdx;
  @override
  final int? followerCnt;
  @override
  final String? profileImgUrl;
  @override
  final String? intro;
  @override
  final int? followCnt;
  @override
  final String? email;

  @override
  String toString() {
    return 'FeedMemberInfoListData(nick: $nick, simpleType: $simpleType, isBadge: $isBadge, memberIdx: $memberIdx, followerCnt: $followerCnt, profileImgUrl: $profileImgUrl, intro: $intro, followCnt: $followCnt, email: $email)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedMemberInfoListData &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.simpleType, simpleType) ||
                other.simpleType == simpleType) &&
            (identical(other.isBadge, isBadge) || other.isBadge == isBadge) &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.followerCnt, followerCnt) ||
                other.followerCnt == followerCnt) &&
            (identical(other.profileImgUrl, profileImgUrl) ||
                other.profileImgUrl == profileImgUrl) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.followCnt, followCnt) ||
                other.followCnt == followCnt) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, nick, simpleType, isBadge,
      memberIdx, followerCnt, profileImgUrl, intro, followCnt, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedMemberInfoListDataCopyWith<_$_FeedMemberInfoListData> get copyWith =>
      __$$_FeedMemberInfoListDataCopyWithImpl<_$_FeedMemberInfoListData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedMemberInfoListDataToJson(
      this,
    );
  }
}

abstract class _FeedMemberInfoListData implements FeedMemberInfoListData {
  factory _FeedMemberInfoListData(
      {final String? nick,
      final String? simpleType,
      final int? isBadge,
      final int? memberIdx,
      final int? followerCnt,
      final String? profileImgUrl,
      final String? intro,
      final int? followCnt,
      final String? email}) = _$_FeedMemberInfoListData;

  factory _FeedMemberInfoListData.fromJson(Map<String, dynamic> json) =
      _$_FeedMemberInfoListData.fromJson;

  @override
  String? get nick;
  @override
  String? get simpleType;
  @override
  int? get isBadge;
  @override
  int? get memberIdx;
  @override
  int? get followerCnt;
  @override
  String? get profileImgUrl;
  @override
  String? get intro;
  @override
  int? get followCnt;
  @override
  String? get email;
  @override
  @JsonKey(ignore: true)
  _$$_FeedMemberInfoListDataCopyWith<_$_FeedMemberInfoListData> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedMentionListData _$FeedMentionListDataFromJson(Map<String, dynamic> json) {
  return _FeedMentionListData.fromJson(json);
}

/// @nodoc
mixin _$FeedMentionListData {
  int? get idx => throw _privateConstructorUsedError;
  String? get uuid => throw _privateConstructorUsedError;
  String? get nick => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedMentionListDataCopyWith<FeedMentionListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedMentionListDataCopyWith<$Res> {
  factory $FeedMentionListDataCopyWith(
          FeedMentionListData value, $Res Function(FeedMentionListData) then) =
      _$FeedMentionListDataCopyWithImpl<$Res, FeedMentionListData>;
  @useResult
  $Res call({int? idx, String? uuid, String? nick});
}

/// @nodoc
class _$FeedMentionListDataCopyWithImpl<$Res, $Val extends FeedMentionListData>
    implements $FeedMentionListDataCopyWith<$Res> {
  _$FeedMentionListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? uuid = freezed,
    Object? nick = freezed,
  }) {
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FeedMentionListDataCopyWith<$Res>
    implements $FeedMentionListDataCopyWith<$Res> {
  factory _$$_FeedMentionListDataCopyWith(_$_FeedMentionListData value,
          $Res Function(_$_FeedMentionListData) then) =
      __$$_FeedMentionListDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? idx, String? uuid, String? nick});
}

/// @nodoc
class __$$_FeedMentionListDataCopyWithImpl<$Res>
    extends _$FeedMentionListDataCopyWithImpl<$Res, _$_FeedMentionListData>
    implements _$$_FeedMentionListDataCopyWith<$Res> {
  __$$_FeedMentionListDataCopyWithImpl(_$_FeedMentionListData _value,
      $Res Function(_$_FeedMentionListData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? uuid = freezed,
    Object? nick = freezed,
  }) {
    return _then(_$_FeedMentionListData(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedMentionListData implements _FeedMentionListData {
  _$_FeedMentionListData({this.idx, this.uuid, this.nick});

  factory _$_FeedMentionListData.fromJson(Map<String, dynamic> json) =>
      _$$_FeedMentionListDataFromJson(json);

  @override
  final int? idx;
  @override
  final String? uuid;
  @override
  final String? nick;

  @override
  String toString() {
    return 'FeedMentionListData(idx: $idx, uuid: $uuid, nick: $nick)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedMentionListData &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.nick, nick) || other.nick == nick));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, idx, uuid, nick);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedMentionListDataCopyWith<_$_FeedMentionListData> get copyWith =>
      __$$_FeedMentionListDataCopyWithImpl<_$_FeedMentionListData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedMentionListDataToJson(
      this,
    );
  }
}

abstract class _FeedMentionListData implements FeedMentionListData {
  factory _FeedMentionListData(
      {final int? idx,
      final String? uuid,
      final String? nick}) = _$_FeedMentionListData;

  factory _FeedMentionListData.fromJson(Map<String, dynamic> json) =
      _$_FeedMentionListData.fromJson;

  @override
  int? get idx;
  @override
  String? get uuid;
  @override
  String? get nick;
  @override
  @JsonKey(ignore: true)
  _$$_FeedMentionListDataCopyWith<_$_FeedMentionListData> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedHashTagListData _$FeedHashTagListDataFromJson(Map<String, dynamic> json) {
  return _FeedHashTagListData.fromJson(json);
}

/// @nodoc
mixin _$FeedHashTagListData {
  int? get idx => throw _privateConstructorUsedError;
  String? get uuid => throw _privateConstructorUsedError;
  String? get nick => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedHashTagListDataCopyWith<FeedHashTagListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedHashTagListDataCopyWith<$Res> {
  factory $FeedHashTagListDataCopyWith(
          FeedHashTagListData value, $Res Function(FeedHashTagListData) then) =
      _$FeedHashTagListDataCopyWithImpl<$Res, FeedHashTagListData>;
  @useResult
  $Res call({int? idx, String? uuid, String? nick});
}

/// @nodoc
class _$FeedHashTagListDataCopyWithImpl<$Res, $Val extends FeedHashTagListData>
    implements $FeedHashTagListDataCopyWith<$Res> {
  _$FeedHashTagListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? uuid = freezed,
    Object? nick = freezed,
  }) {
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FeedHashTagListDataCopyWith<$Res>
    implements $FeedHashTagListDataCopyWith<$Res> {
  factory _$$_FeedHashTagListDataCopyWith(_$_FeedHashTagListData value,
          $Res Function(_$_FeedHashTagListData) then) =
      __$$_FeedHashTagListDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? idx, String? uuid, String? nick});
}

/// @nodoc
class __$$_FeedHashTagListDataCopyWithImpl<$Res>
    extends _$FeedHashTagListDataCopyWithImpl<$Res, _$_FeedHashTagListData>
    implements _$$_FeedHashTagListDataCopyWith<$Res> {
  __$$_FeedHashTagListDataCopyWithImpl(_$_FeedHashTagListData _value,
      $Res Function(_$_FeedHashTagListData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? uuid = freezed,
    Object? nick = freezed,
  }) {
    return _then(_$_FeedHashTagListData(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedHashTagListData implements _FeedHashTagListData {
  _$_FeedHashTagListData({this.idx, this.uuid, this.nick});

  factory _$_FeedHashTagListData.fromJson(Map<String, dynamic> json) =>
      _$$_FeedHashTagListDataFromJson(json);

  @override
  final int? idx;
  @override
  final String? uuid;
  @override
  final String? nick;

  @override
  String toString() {
    return 'FeedHashTagListData(idx: $idx, uuid: $uuid, nick: $nick)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedHashTagListData &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.nick, nick) || other.nick == nick));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, idx, uuid, nick);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedHashTagListDataCopyWith<_$_FeedHashTagListData> get copyWith =>
      __$$_FeedHashTagListDataCopyWithImpl<_$_FeedHashTagListData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedHashTagListDataToJson(
      this,
    );
  }
}

abstract class _FeedHashTagListData implements FeedHashTagListData {
  factory _FeedHashTagListData(
      {final int? idx,
      final String? uuid,
      final String? nick}) = _$_FeedHashTagListData;

  factory _FeedHashTagListData.fromJson(Map<String, dynamic> json) =
      _$_FeedHashTagListData.fromJson;

  @override
  int? get idx;
  @override
  String? get uuid;
  @override
  String? get nick;
  @override
  @JsonKey(ignore: true)
  _$$_FeedHashTagListDataCopyWith<_$_FeedHashTagListData> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedImgListData _$FeedImgListDataFromJson(Map<String, dynamic> json) {
  return _FeedImgListData.fromJson(json);
}

/// @nodoc
mixin _$FeedImgListData {
  int? get imgWidth => throw _privateConstructorUsedError;
  int? get imgHeight => throw _privateConstructorUsedError;
  int? get idx => throw _privateConstructorUsedError;
  List<ImgMemberTagListData>? get imgMemberTagList =>
      throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedImgListDataCopyWith<FeedImgListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedImgListDataCopyWith<$Res> {
  factory $FeedImgListDataCopyWith(
          FeedImgListData value, $Res Function(FeedImgListData) then) =
      _$FeedImgListDataCopyWithImpl<$Res, FeedImgListData>;
  @useResult
  $Res call(
      {int? imgWidth,
      int? imgHeight,
      int? idx,
      List<ImgMemberTagListData>? imgMemberTagList,
      String? url});
}

/// @nodoc
class _$FeedImgListDataCopyWithImpl<$Res, $Val extends FeedImgListData>
    implements $FeedImgListDataCopyWith<$Res> {
  _$FeedImgListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imgWidth = freezed,
    Object? imgHeight = freezed,
    Object? idx = freezed,
    Object? imgMemberTagList = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      imgWidth: freezed == imgWidth
          ? _value.imgWidth
          : imgWidth // ignore: cast_nullable_to_non_nullable
              as int?,
      imgHeight: freezed == imgHeight
          ? _value.imgHeight
          : imgHeight // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      imgMemberTagList: freezed == imgMemberTagList
          ? _value.imgMemberTagList
          : imgMemberTagList // ignore: cast_nullable_to_non_nullable
              as List<ImgMemberTagListData>?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FeedImgListDataCopyWith<$Res>
    implements $FeedImgListDataCopyWith<$Res> {
  factory _$$_FeedImgListDataCopyWith(
          _$_FeedImgListData value, $Res Function(_$_FeedImgListData) then) =
      __$$_FeedImgListDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? imgWidth,
      int? imgHeight,
      int? idx,
      List<ImgMemberTagListData>? imgMemberTagList,
      String? url});
}

/// @nodoc
class __$$_FeedImgListDataCopyWithImpl<$Res>
    extends _$FeedImgListDataCopyWithImpl<$Res, _$_FeedImgListData>
    implements _$$_FeedImgListDataCopyWith<$Res> {
  __$$_FeedImgListDataCopyWithImpl(
      _$_FeedImgListData _value, $Res Function(_$_FeedImgListData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imgWidth = freezed,
    Object? imgHeight = freezed,
    Object? idx = freezed,
    Object? imgMemberTagList = freezed,
    Object? url = freezed,
  }) {
    return _then(_$_FeedImgListData(
      imgWidth: freezed == imgWidth
          ? _value.imgWidth
          : imgWidth // ignore: cast_nullable_to_non_nullable
              as int?,
      imgHeight: freezed == imgHeight
          ? _value.imgHeight
          : imgHeight // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
      imgMemberTagList: freezed == imgMemberTagList
          ? _value._imgMemberTagList
          : imgMemberTagList // ignore: cast_nullable_to_non_nullable
              as List<ImgMemberTagListData>?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedImgListData implements _FeedImgListData {
  _$_FeedImgListData(
      {this.imgWidth,
      this.imgHeight,
      this.idx,
      final List<ImgMemberTagListData>? imgMemberTagList,
      this.url})
      : _imgMemberTagList = imgMemberTagList;

  factory _$_FeedImgListData.fromJson(Map<String, dynamic> json) =>
      _$$_FeedImgListDataFromJson(json);

  @override
  final int? imgWidth;
  @override
  final int? imgHeight;
  @override
  final int? idx;
  final List<ImgMemberTagListData>? _imgMemberTagList;
  @override
  List<ImgMemberTagListData>? get imgMemberTagList {
    final value = _imgMemberTagList;
    if (value == null) return null;
    if (_imgMemberTagList is EqualUnmodifiableListView)
      return _imgMemberTagList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? url;

  @override
  String toString() {
    return 'FeedImgListData(imgWidth: $imgWidth, imgHeight: $imgHeight, idx: $idx, imgMemberTagList: $imgMemberTagList, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedImgListData &&
            (identical(other.imgWidth, imgWidth) ||
                other.imgWidth == imgWidth) &&
            (identical(other.imgHeight, imgHeight) ||
                other.imgHeight == imgHeight) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            const DeepCollectionEquality()
                .equals(other._imgMemberTagList, _imgMemberTagList) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, imgWidth, imgHeight, idx,
      const DeepCollectionEquality().hash(_imgMemberTagList), url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedImgListDataCopyWith<_$_FeedImgListData> get copyWith =>
      __$$_FeedImgListDataCopyWithImpl<_$_FeedImgListData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedImgListDataToJson(
      this,
    );
  }
}

abstract class _FeedImgListData implements FeedImgListData {
  factory _FeedImgListData(
      {final int? imgWidth,
      final int? imgHeight,
      final int? idx,
      final List<ImgMemberTagListData>? imgMemberTagList,
      final String? url}) = _$_FeedImgListData;

  factory _FeedImgListData.fromJson(Map<String, dynamic> json) =
      _$_FeedImgListData.fromJson;

  @override
  int? get imgWidth;
  @override
  int? get imgHeight;
  @override
  int? get idx;
  @override
  List<ImgMemberTagListData>? get imgMemberTagList;
  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$_FeedImgListDataCopyWith<_$_FeedImgListData> get copyWith =>
      throw _privateConstructorUsedError;
}

ImgMemberTagListData _$ImgMemberTagListDataFromJson(Map<String, dynamic> json) {
  return _ImgMemberTagListData.fromJson(json);
}

/// @nodoc
mixin _$ImgMemberTagListData {
  int? get imgIdx => throw _privateConstructorUsedError;
  int? get memberIdx => throw _privateConstructorUsedError;
  int? get isBadge => throw _privateConstructorUsedError;
  String? get profileImgUrl => throw _privateConstructorUsedError;
  int? get followState => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImgMemberTagListDataCopyWith<ImgMemberTagListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImgMemberTagListDataCopyWith<$Res> {
  factory $ImgMemberTagListDataCopyWith(ImgMemberTagListData value,
          $Res Function(ImgMemberTagListData) then) =
      _$ImgMemberTagListDataCopyWithImpl<$Res, ImgMemberTagListData>;
  @useResult
  $Res call(
      {int? imgIdx,
      int? memberIdx,
      int? isBadge,
      String? profileImgUrl,
      int? followState,
      int? width,
      int? height});
}

/// @nodoc
class _$ImgMemberTagListDataCopyWithImpl<$Res,
        $Val extends ImgMemberTagListData>
    implements $ImgMemberTagListDataCopyWith<$Res> {
  _$ImgMemberTagListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imgIdx = freezed,
    Object? memberIdx = freezed,
    Object? isBadge = freezed,
    Object? profileImgUrl = freezed,
    Object? followState = freezed,
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(_value.copyWith(
      imgIdx: freezed == imgIdx
          ? _value.imgIdx
          : imgIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      followState: freezed == followState
          ? _value.followState
          : followState // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImgMemberTagListDataCopyWith<$Res>
    implements $ImgMemberTagListDataCopyWith<$Res> {
  factory _$$_ImgMemberTagListDataCopyWith(_$_ImgMemberTagListData value,
          $Res Function(_$_ImgMemberTagListData) then) =
      __$$_ImgMemberTagListDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? imgIdx,
      int? memberIdx,
      int? isBadge,
      String? profileImgUrl,
      int? followState,
      int? width,
      int? height});
}

/// @nodoc
class __$$_ImgMemberTagListDataCopyWithImpl<$Res>
    extends _$ImgMemberTagListDataCopyWithImpl<$Res, _$_ImgMemberTagListData>
    implements _$$_ImgMemberTagListDataCopyWith<$Res> {
  __$$_ImgMemberTagListDataCopyWithImpl(_$_ImgMemberTagListData _value,
      $Res Function(_$_ImgMemberTagListData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imgIdx = freezed,
    Object? memberIdx = freezed,
    Object? isBadge = freezed,
    Object? profileImgUrl = freezed,
    Object? followState = freezed,
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(_$_ImgMemberTagListData(
      imgIdx: freezed == imgIdx
          ? _value.imgIdx
          : imgIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      followState: freezed == followState
          ? _value.followState
          : followState // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ImgMemberTagListData implements _ImgMemberTagListData {
  _$_ImgMemberTagListData(
      {this.imgIdx,
      this.memberIdx,
      this.isBadge,
      this.profileImgUrl,
      this.followState,
      this.width,
      this.height});

  factory _$_ImgMemberTagListData.fromJson(Map<String, dynamic> json) =>
      _$$_ImgMemberTagListDataFromJson(json);

  @override
  final int? imgIdx;
  @override
  final int? memberIdx;
  @override
  final int? isBadge;
  @override
  final String? profileImgUrl;
  @override
  final int? followState;
  @override
  final int? width;
  @override
  final int? height;

  @override
  String toString() {
    return 'ImgMemberTagListData(imgIdx: $imgIdx, memberIdx: $memberIdx, isBadge: $isBadge, profileImgUrl: $profileImgUrl, followState: $followState, width: $width, height: $height)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImgMemberTagListData &&
            (identical(other.imgIdx, imgIdx) || other.imgIdx == imgIdx) &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.isBadge, isBadge) || other.isBadge == isBadge) &&
            (identical(other.profileImgUrl, profileImgUrl) ||
                other.profileImgUrl == profileImgUrl) &&
            (identical(other.followState, followState) ||
                other.followState == followState) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, imgIdx, memberIdx, isBadge,
      profileImgUrl, followState, width, height);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImgMemberTagListDataCopyWith<_$_ImgMemberTagListData> get copyWith =>
      __$$_ImgMemberTagListDataCopyWithImpl<_$_ImgMemberTagListData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ImgMemberTagListDataToJson(
      this,
    );
  }
}

abstract class _ImgMemberTagListData implements ImgMemberTagListData {
  factory _ImgMemberTagListData(
      {final int? imgIdx,
      final int? memberIdx,
      final int? isBadge,
      final String? profileImgUrl,
      final int? followState,
      final int? width,
      final int? height}) = _$_ImgMemberTagListData;

  factory _ImgMemberTagListData.fromJson(Map<String, dynamic> json) =
      _$_ImgMemberTagListData.fromJson;

  @override
  int? get imgIdx;
  @override
  int? get memberIdx;
  @override
  int? get isBadge;
  @override
  String? get profileImgUrl;
  @override
  int? get followState;
  @override
  int? get width;
  @override
  int? get height;
  @override
  @JsonKey(ignore: true)
  _$$_ImgMemberTagListDataCopyWith<_$_ImgMemberTagListData> get copyWith =>
      throw _privateConstructorUsedError;
}
