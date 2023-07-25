// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatFavoriteModel _$$_ChatFavoriteModelFromJson(Map<String, dynamic> json) =>
    _$_ChatFavoriteModel(
      memberIdx: json['memberIdx'] as int,
      isBadge: json['isBadge'] as int,
      nick: json['nick'] as String,
      profileImgUrl: json['profileImgUrl'] as String,
      chatInfo: _parseChatInfo(json['chatInfo'] as Object),
    );

Map<String, dynamic> _$$_ChatFavoriteModelToJson(
        _$_ChatFavoriteModel instance) =>
    <String, dynamic>{
      'memberIdx': instance.memberIdx,
      'isBadge': instance.isBadge,
      'nick': instance.nick,
      'profileImgUrl': instance.profileImgUrl,
      'chatInfo': instance.chatInfo,
    };
