import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_data.freezed.dart';
part 'feed_data.g.dart';

@freezed
class FeedData with _$FeedData {
  factory FeedData({
    FeedCommentData? comment,
    int? keepState,
    int? followState,
    int? isComment,
    int? isLike,
    int? saveState,
    int? isView,
    String? regDate,
    int? likeState,
    int? imageCnt,
    String? uuid,
    String? memberUuid,
    String? workUuid,
    int? likeCnt,
    String? contents,
    String? location,
    int? modifyState,
    required int idx,
    List<MentionListData>? mentionList,
    int? commentCnt,
    List<FeedHashTagListData>? hashTagList,
    MemberInfoData? memberInfo,
    List<FeedImgListData>? imgList,
    // List<WalkResultListData>? walkResultList,
  }) = _FeedData;

  factory FeedData.fromJson(Map<String, dynamic> json) => _$FeedDataFromJson(json);
}

@freezed
class FeedCommentData with _$FeedCommentData {
  factory FeedCommentData({
    String? nick,
    int? likeCnt,
    int? isBadge,
    String? memberUuid,
    String? contents,
    String? regDate,
    int? likeState,
    int? idx,
    String? profileImgUrl,
    List<MentionListData>? mentionList,
  }) = _FeedCommentData;

  factory FeedCommentData.fromJson(Map<String, dynamic> json) => _$FeedCommentDataFromJson(json);
}

@freezed
class MentionListData with _$MentionListData {
  factory MentionListData({
    String? memberUuid,
    String? uuid,
    String? nick,
    int? memberState,
  }) = _MentionListData;

  factory MentionListData.fromJson(Map<String, dynamic> json) => _$MentionListDataFromJson(json);
}

@freezed
class FeedHashTagListData with _$FeedHashTagListData {
  factory FeedHashTagListData({
    int? idx,
    String? uuid,
    String? nick,
  }) = _FeedHashTagListData;

  factory FeedHashTagListData.fromJson(Map<String, dynamic> json) => _$FeedHashTagListDataFromJson(json);
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

  factory FeedImgListData.fromJson(Map<String, dynamic> json) => _$FeedImgListDataFromJson(json);
}

@freezed
class ImgMemberTagListData with _$ImgMemberTagListData {
  factory ImgMemberTagListData({
    String? nick,
    int? imgIdx,
    String? memberUuid,
    int? isBadge,
    String? profileImgUrl,
    int? followState,
    double? width,
    double? height,
    String? intro,
  }) = _ImgMemberTagListData;

  factory ImgMemberTagListData.fromJson(Map<String, dynamic> json) => _$ImgMemberTagListDataFromJson(json);
}

@freezed
class MemberInfoData with _$MemberInfoData {
  factory MemberInfoData({
    String? simpleType,
    String? nick,
    int? isBadge,
    String? uuid,
    int? followerCnt,
    String? intro,
    String? profileImgUrl,
    int? followCnt,
    String? email,
  }) = _MemberInfoData;

  factory MemberInfoData.fromJson(Map<String, dynamic> json) => _$MemberInfoDataFromJson(json);
}

// @freezed
// class WalkResultListData with _$WalkResultListData {
//   factory WalkResultListData({
//     double? distance,
//     String? memberUuid,
//     String? endDate,
//     double? calorie,
//     String? walkTime,
//     int? step,
//     String? walkUuid,
//     String? startDate,
//     int? together,
//     List<MemberInfoData>? walkMemberList,
//   }) = _WalkResultListData;
//
//   factory WalkResultListData.fromJson(Map<String, dynamic> json) => _$WalkResultListDataFromJson(json);
// }
