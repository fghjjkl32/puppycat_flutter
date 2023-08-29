import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_data.freezed.dart';
part 'feed_data.g.dart';

@freezed
class FeedData with _$FeedData {
  factory FeedData({
    List<FeedCommentData>? commentList,
    int? keepState,
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
    required int idx,
    List<MentionListData>? mentionList,
    int? commentCnt,
    List<FeedHashTagListData>? hashTagList,
    List<MemberInfoListData>? memberInfoList,
    List<FeedImgListData>? imgList,
  }) = _FeedData;

  factory FeedData.fromJson(Map<String, dynamic> json) =>
      _$FeedDataFromJson(json);
}

@freezed
class FeedCommentData with _$FeedCommentData {
  factory FeedCommentData({
    String? nick,
    int? likeCnt,
    int? isBadge,
    int? memberIdx,
    String? contents,
    String? regDate,
    int? likeState,
    int? idx,
    String? profileImgUrl,
    List<MentionListData>? mentionList,
  }) = _FeedCommentData;

  factory FeedCommentData.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentDataFromJson(json);
}

@freezed
class FeedMemberInfoListData with _$FeedMemberInfoListData {
  factory FeedMemberInfoListData({
    String? nick,
    String? simpleType,
    int? isBadge,
    int? memberIdx,
    int? followerCnt,
    String? profileImgUrl,
    String? intro,
    int? followCnt,
    String? email,
  }) = _FeedMemberInfoListData;

  factory FeedMemberInfoListData.fromJson(Map<String, dynamic> json) =>
      _$FeedMemberInfoListDataFromJson(json);
}

@freezed
class MentionListData with _$MentionListData {
  factory MentionListData({
    int? memberIdx,
    String? uuid,
    String? nick,
    int? memberState,
  }) = _MentionListData;

  factory MentionListData.fromJson(Map<String, dynamic> json) =>
      _$MentionListDataFromJson(json);
}

@freezed
class FeedHashTagListData with _$FeedHashTagListData {
  factory FeedHashTagListData({
    int? idx,
    String? uuid,
    String? nick,
  }) = _FeedHashTagListData;

  factory FeedHashTagListData.fromJson(Map<String, dynamic> json) =>
      _$FeedHashTagListDataFromJson(json);
}

@freezed
class FeedImgListData with _$FeedImgListData {
  factory FeedImgListData({
    int? imgWidth,
    int? imgHeight,
    int? idx,
    List<ImgMemberTagListData>? imgMemberTagList,
    String? url,
  }) = _FeedImgListData;

  factory FeedImgListData.fromJson(Map<String, dynamic> json) =>
      _$FeedImgListDataFromJson(json);
}

@freezed
class ImgMemberTagListData with _$ImgMemberTagListData {
  factory ImgMemberTagListData({
    String? nick,
    int? imgIdx,
    int? memberIdx,
    int? isBadge,
    String? profileImgUrl,
    int? followState,
    double? width,
    double? height,
    String? intro,
  }) = _ImgMemberTagListData;

  factory ImgMemberTagListData.fromJson(Map<String, dynamic> json) =>
      _$ImgMemberTagListDataFromJson(json);
}

@freezed
class MemberInfoListData with _$MemberInfoListData {
  factory MemberInfoListData({
    String? simpleType,
    String? nick,
    int? isBadge,
    int? memberIdx,
    int? followerCnt,
    String? intro,
    String? profileImgUrl,
    int? followCnt,
    String? email,
  }) = _MemberInfoListData;

  factory MemberInfoListData.fromJson(Map<String, dynamic> json) =>
      _$MemberInfoListDataFromJson(json);
}
