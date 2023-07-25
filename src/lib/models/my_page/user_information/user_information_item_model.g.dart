// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserInformationItemModel _$$_UserInformationItemModelFromJson(
        Map<String, dynamic> json) =>
    _$_UserInformationItemModel(
      memberIdx: json['memberIdx'] as int?,
      nick: json['nick'] as String?,
      simpleType: json['simpleType'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      intro: json['intro'] as String?,
      profileImgUrl: json['profileImgUrl'] as String?,
      email: json['email'] as String?,
      followerCnt: json['followerCnt'] as int?,
      followCnt: json['followCnt'] as int?,
      blockedState: json['blockedState'] as int?,
      blockedMeState: json['blockedMeState'] as int?,
      followState: json['followState'] as int?,
      chatAccessToken: json['chatAccessToken'] as String?,
      chatMemeberId: json['chatMemeberId'] as String?,
      homeServer: json['homeServer'] as String?,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$$_UserInformationItemModelToJson(
        _$_UserInformationItemModel instance) =>
    <String, dynamic>{
      'memberIdx': instance.memberIdx,
      'nick': instance.nick,
      'simpleType': instance.simpleType,
      'name': instance.name,
      'phone': instance.phone,
      'intro': instance.intro,
      'profileImgUrl': instance.profileImgUrl,
      'email': instance.email,
      'followerCnt': instance.followerCnt,
      'followCnt': instance.followCnt,
      'blockedState': instance.blockedState,
      'blockedMeState': instance.blockedMeState,
      'followState': instance.followState,
      'chatAccessToken': instance.chatAccessToken,
      'chatMemeberId': instance.chatMemeberId,
      'homeServer': instance.homeServer,
      'deviceId': instance.deviceId,
    };
