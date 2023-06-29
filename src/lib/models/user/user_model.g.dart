// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      loginStatus: $enumDecode(_$LoginStatusEnumMap, json['loginStatus']),
      idx: json['idx'] as int,
      appKey: json['appKey'] as String? ?? '',
      nick: json['nick'] as String,
      id: json['id'] as String,
      simpleId: json['simpleId'] as String,
      credentialToken: json['credentialToken'] as String?,
      refreshToken: json['refreshToken'] as String,
      isSimple: json['isSimple'] as int,
      simpleType: json['simpleType'] as String,
      accessToken: json['accessToken'] as String,
      password: json['password'] as String,
      passwordConfirm: json['passwordConfirm'] as String,
      partner: json['partner'] as String? ?? '',
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'loginStatus': _$LoginStatusEnumMap[instance.loginStatus]!,
      'idx': instance.idx,
      'appKey': instance.appKey,
      'nick': instance.nick,
      'id': instance.id,
      'simpleId': instance.simpleId,
      'credentialToken': instance.credentialToken,
      'refreshToken': instance.refreshToken,
      'isSimple': instance.isSimple,
      'simpleType': instance.simpleType,
      'accessToken': instance.accessToken,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
      'partner': instance.partner,
    };

const _$LoginStatusEnumMap = {
  LoginStatus.none: 'none',
  LoginStatus.success: 'success',
  LoginStatus.failure: 'failure',
  LoginStatus.needSignUp: 'needSignUp',
  LoginStatus.restriction: 'restriction',
  LoginStatus.withdrawalPending: 'withdrawalPending',
  LoginStatus.fourteen: 'fourteen',
};
