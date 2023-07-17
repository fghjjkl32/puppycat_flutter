// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_like_user_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ContentLikeUserListData _$$_ContentLikeUserListDataFromJson(
        Map<String, dynamic> json) =>
    _$_ContentLikeUserListData(
      nick: json['nick'] as String,
      isFollow: json['isFollow'] as int,
      isBadge: json['isBadge'] as int,
      memberIdx: json['memberIdx'] as int,
      followerCnt: json['followerCnt'] as int,
      intro: json['intro'] as String,
      profileImgUrl: json['profileImgUrl'] as String,
    );

Map<String, dynamic> _$$_ContentLikeUserListDataToJson(
        _$_ContentLikeUserListData instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'isFollow': instance.isFollow,
      'isBadge': instance.isBadge,
      'memberIdx': instance.memberIdx,
      'followerCnt': instance.followerCnt,
      'intro': instance.intro,
      'profileImgUrl': instance.profileImgUrl,
    };
