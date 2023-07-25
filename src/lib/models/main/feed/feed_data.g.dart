// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedData _$$_FeedDataFromJson(Map<String, dynamic> json) => _$_FeedData(
      commentList: (json['commentList'] as List<dynamic>?)
          ?.map((e) => FeedCommentData.fromJson(e as Map<String, dynamic>))
          .toList(),
      followState: json['followState'] as int?,
      isComment: json['isComment'] as int?,
      memberIdx: json['memberIdx'] as int?,
      isLike: json['isLike'] as int?,
      saveState: json['saveState'] as int?,
      isView: json['isView'] as int?,
      regDate: json['regDate'] as String?,
      likeState: json['likeState'] as int?,
      imageCnt: json['imageCnt'] as int?,
      uuid: json['uuid'] as String?,
      likeCnt: json['likeCnt'] as int?,
      contents: json['contents'] as String?,
      location: json['location'] as String?,
      modifyState: json['modifyState'] as int?,
      idx: json['idx'] as int,
      mentionList: (json['mentionList'] as List<dynamic>?)
          ?.map((e) => FeedMentionListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      commentCnt: json['commentCnt'] as int?,
      hashTagList: (json['hashTagList'] as List<dynamic>?)
          ?.map((e) => FeedHashTagListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      imgList: (json['imgList'] as List<dynamic>?)
          ?.map((e) => FeedImgListData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_FeedDataToJson(_$_FeedData instance) =>
    <String, dynamic>{
      'commentList': instance.commentList,
      'followState': instance.followState,
      'isComment': instance.isComment,
      'memberIdx': instance.memberIdx,
      'isLike': instance.isLike,
      'saveState': instance.saveState,
      'isView': instance.isView,
      'regDate': instance.regDate,
      'likeState': instance.likeState,
      'imageCnt': instance.imageCnt,
      'uuid': instance.uuid,
      'likeCnt': instance.likeCnt,
      'contents': instance.contents,
      'location': instance.location,
      'modifyState': instance.modifyState,
      'idx': instance.idx,
      'mentionList': instance.mentionList,
      'commentCnt': instance.commentCnt,
      'hashTagList': instance.hashTagList,
      'imgList': instance.imgList,
    };

_$_FeedCommentData _$$_FeedCommentDataFromJson(Map<String, dynamic> json) =>
    _$_FeedCommentData(
      nick: json['nick'] as String?,
      likeCnt: json['likeCnt'] as int?,
      isBadge: json['isBadge'] as int?,
      memberIdx: json['memberIdx'] as int?,
      contents: json['contents'] as String?,
      regDate: json['regDate'] as String?,
      likeState: json['likeState'] as int?,
      idx: json['idx'] as int?,
      profileImgUrl: json['profileImgUrl'] as String?,
    );

Map<String, dynamic> _$$_FeedCommentDataToJson(_$_FeedCommentData instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'likeCnt': instance.likeCnt,
      'isBadge': instance.isBadge,
      'memberIdx': instance.memberIdx,
      'contents': instance.contents,
      'regDate': instance.regDate,
      'likeState': instance.likeState,
      'idx': instance.idx,
      'profileImgUrl': instance.profileImgUrl,
    };

_$_FeedMemberInfoListData _$$_FeedMemberInfoListDataFromJson(
        Map<String, dynamic> json) =>
    _$_FeedMemberInfoListData(
      nick: json['nick'] as String?,
      simpleType: json['simpleType'] as String?,
      isBadge: json['isBadge'] as int?,
      memberIdx: json['memberIdx'] as int?,
      followerCnt: json['followerCnt'] as int?,
      profileImgUrl: json['profileImgUrl'] as String?,
      intro: json['intro'] as String?,
      followCnt: json['followCnt'] as int?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$_FeedMemberInfoListDataToJson(
        _$_FeedMemberInfoListData instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'simpleType': instance.simpleType,
      'isBadge': instance.isBadge,
      'memberIdx': instance.memberIdx,
      'followerCnt': instance.followerCnt,
      'profileImgUrl': instance.profileImgUrl,
      'intro': instance.intro,
      'followCnt': instance.followCnt,
      'email': instance.email,
    };

_$_FeedMentionListData _$$_FeedMentionListDataFromJson(
        Map<String, dynamic> json) =>
    _$_FeedMentionListData(
      idx: json['idx'] as int?,
      uuid: json['uuid'] as String?,
      nick: json['nick'] as String?,
    );

Map<String, dynamic> _$$_FeedMentionListDataToJson(
        _$_FeedMentionListData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'uuid': instance.uuid,
      'nick': instance.nick,
    };

_$_FeedHashTagListData _$$_FeedHashTagListDataFromJson(
        Map<String, dynamic> json) =>
    _$_FeedHashTagListData(
      idx: json['idx'] as int?,
      uuid: json['uuid'] as String?,
      nick: json['nick'] as String?,
    );

Map<String, dynamic> _$$_FeedHashTagListDataToJson(
        _$_FeedHashTagListData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'uuid': instance.uuid,
      'nick': instance.nick,
    };

_$_FeedImgListData _$$_FeedImgListDataFromJson(Map<String, dynamic> json) =>
    _$_FeedImgListData(
      imgWidth: json['imgWidth'] as int?,
      imgHeight: json['imgHeight'] as int?,
      idx: json['idx'] as int?,
      imgMemberTagList: (json['imgMemberTagList'] as List<dynamic>?)
          ?.map((e) => ImgMemberTagListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$_FeedImgListDataToJson(_$_FeedImgListData instance) =>
    <String, dynamic>{
      'imgWidth': instance.imgWidth,
      'imgHeight': instance.imgHeight,
      'idx': instance.idx,
      'imgMemberTagList': instance.imgMemberTagList,
      'url': instance.url,
    };

_$_ImgMemberTagListData _$$_ImgMemberTagListDataFromJson(
        Map<String, dynamic> json) =>
    _$_ImgMemberTagListData(
      imgIdx: json['imgIdx'] as int?,
      memberIdx: json['memberIdx'] as int?,
      isBadge: json['isBadge'] as int?,
      profileImgUrl: json['profileImgUrl'] as String?,
      followState: json['followState'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );

Map<String, dynamic> _$$_ImgMemberTagListDataToJson(
        _$_ImgMemberTagListData instance) =>
    <String, dynamic>{
      'imgIdx': instance.imgIdx,
      'memberIdx': instance.memberIdx,
      'isBadge': instance.isBadge,
      'profileImgUrl': instance.profileImgUrl,
      'followState': instance.followState,
      'width': instance.width,
      'height': instance.height,
    };
