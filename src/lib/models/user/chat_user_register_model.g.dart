// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatUserRegisterModel _$$_ChatUserRegisterModelFromJson(
        Map<String, dynamic> json) =>
    _$_ChatUserRegisterModel(
      chatMemberId: json['chatMemberId'] as String?,
      homeServer: json['homeServer'] as String?,
      accessToken: json['accessToken'] as String?,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$$_ChatUserRegisterModelToJson(
        _$_ChatUserRegisterModel instance) =>
    <String, dynamic>{
      'chatMemberId': instance.chatMemberId,
      'homeServer': instance.homeServer,
      'accessToken': instance.accessToken,
      'deviceId': instance.deviceId,
    };
