// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_msg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatMessageModel _$$_ChatMessageModelFromJson(Map<String, dynamic> json) =>
    _$_ChatMessageModel(
      idx: json['idx'] as int,
      id: json['id'] as String,
      isMine: json['isMine'] as bool,
      userID: json['userID'] as String,
      avatarUrl: json['avatarUrl'] as String,
      msg: json['msg'] as String,
      dateTime: json['dateTime'] as String,
      isEdited: json['isEdited'] as bool,
      reaction: json['reaction'] as int,
      hasReaction: json['hasReaction'] as bool,
      isReply: json['isReply'] as bool,
      replyTargetNick: json['replyTargetNick'] as String?,
      replyTargetMsg: json['replyTargetMsg'] as String?,
      isRead: json['isRead'] as bool,
      isConsecutively: json['isConsecutively'] as bool,
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_ChatMessageModelToJson(_$_ChatMessageModel instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'id': instance.id,
      'isMine': instance.isMine,
      'userID': instance.userID,
      'avatarUrl': instance.avatarUrl,
      'msg': instance.msg,
      'dateTime': instance.dateTime,
      'isEdited': instance.isEdited,
      'reaction': instance.reaction,
      'hasReaction': instance.hasReaction,
      'isReply': instance.isReply,
      'replyTargetNick': instance.replyTargetNick,
      'replyTargetMsg': instance.replyTargetMsg,
      'isRead': instance.isRead,
      'isConsecutively': instance.isConsecutively,
      'reactions': instance.reactions,
    };
