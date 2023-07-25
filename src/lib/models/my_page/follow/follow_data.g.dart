// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FollowData _$$_FollowDataFromJson(Map<String, dynamic> json) =>
    _$_FollowData(
      followNick: json['followNick'] as String?,
      followerNick: json['followerNick'] as String?,
      url: json['url'] as String?,
      isBadge: json['isBadge'] as int?,
      memberIdx: json['memberIdx'] as int?,
      followerCnt: json['followerCnt'] as int?,
      regDate: json['regDate'] as String?,
      followIdx: json['followIdx'] as int?,
      newState: json['newState'] as int?,
      intro: json['intro'] as String?,
      isFollow: json['isFollow'] as int?,
      followerIdx: json['followerIdx'] as int?,
      followerId: json['followerId'] as String?,
    );

Map<String, dynamic> _$$_FollowDataToJson(_$_FollowData instance) =>
    <String, dynamic>{
      'followNick': instance.followNick,
      'followerNick': instance.followerNick,
      'url': instance.url,
      'isBadge': instance.isBadge,
      'memberIdx': instance.memberIdx,
      'followerCnt': instance.followerCnt,
      'regDate': instance.regDate,
      'followIdx': instance.followIdx,
      'newState': instance.newState,
      'intro': instance.intro,
      'isFollow': instance.isFollow,
      'followerIdx': instance.followerIdx,
      'followerId': instance.followerId,
    };
