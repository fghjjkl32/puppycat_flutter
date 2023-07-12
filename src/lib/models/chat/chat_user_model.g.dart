// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatUserModel _$$_ChatUserModelFromJson(Map<String, dynamic> json) =>
    _$_ChatUserModel(
      chatMemberId: json['user_id'] as String?,
      accessToken: json['access_token'] as String?,
      homeServer: json['home_server'] as String?,
      deviceId: json['device_id'] as String?,
    );

Map<String, dynamic> _$$_ChatUserModelToJson(_$_ChatUserModel instance) =>
    <String, dynamic>{
      'user_id': instance.chatMemberId,
      'access_token': instance.accessToken,
      'home_server': instance.homeServer,
      'device_id': instance.deviceId,
    };
