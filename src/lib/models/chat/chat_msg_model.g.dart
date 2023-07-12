// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_msg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatMessageModel _$$_ChatMessageModelFromJson(Map<String, dynamic> json) =>
    _$_ChatMessageModel(
      isMine: json['isMine'] as bool,
      userID: json['userID'] as String,
      avatarUrl: json['avatarUrl'] as String,
      msg: json['msg'] as String,
      dateTime: json['dateTime'] as String,
      isEdited: json['isEdited'] as bool,
      reaction: json['reaction'] as int,
      isReply: json['isReply'] as bool,
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$$_ChatMessageModelToJson(_$_ChatMessageModel instance) =>
    <String, dynamic>{
      'isMine': instance.isMine,
      'userID': instance.userID,
      'avatarUrl': instance.avatarUrl,
      'msg': instance.msg,
      'dateTime': instance.dateTime,
      'isEdited': instance.isEdited,
      'reaction': instance.reaction,
      'isReply': instance.isReply,
      'isRead': instance.isRead,
    };
