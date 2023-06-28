// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LoginRequestModel _$$_LoginRequestModelFromJson(Map<String, dynamic> json) =>
    _$_LoginRequestModel(
      id: json['id'] as String,
      simpleId: json['simpleId'] as String,
      isSimple: json['isSimple'] as int? ?? 1,
      simpleType: json['simpleType'] as String,
      appKey: json['appKey'] as String,
      appVer: json['appVer'] as String,
      domain: json['domain'] as String? ?? 'puppycat.co.kr',
      iso: json['iso'] as String? ?? 'ko',
      fcmToken: json['fcmToken'] as String,
    );

Map<String, dynamic> _$$_LoginRequestModelToJson(
        _$_LoginRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'simpleId': instance.simpleId,
      'isSimple': instance.isSimple,
      'simpleType': instance.simpleType,
      'appKey': instance.appKey,
      'appVer': instance.appVer,
      'domain': instance.domain,
      'iso': instance.iso,
      'fcmToken': instance.fcmToken,
    };
