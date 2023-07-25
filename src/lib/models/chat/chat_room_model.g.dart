// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatRoomModel _$$_ChatRoomModelFromJson(Map<String, dynamic> json) =>
    _$_ChatRoomModel(
      id: json['id'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      nick: json['nick'] as String,
      lastMsg: json['lastMsg'] as String,
      isLastMsgMine: json['isLastMsgMine'] as bool,
      newCount: json['newCount'] as int,
      isRead: json['isRead'] as bool,
      isPin: json['isPin'] as bool,
      msgDateTime: json['msgDateTime'] as String,
      isMine: json['isMine'] as bool,
      isJoined: json['isJoined'] as bool,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$_ChatRoomModelToJson(_$_ChatRoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatarUrl': instance.avatarUrl,
      'nick': instance.nick,
      'lastMsg': instance.lastMsg,
      'isLastMsgMine': instance.isLastMsgMine,
      'newCount': instance.newCount,
      'isRead': instance.isRead,
      'isPin': instance.isPin,
      'msgDateTime': instance.msgDateTime,
      'isMine': instance.isMine,
      'isJoined': instance.isJoined,
      'isFavorite': instance.isFavorite,
    };
