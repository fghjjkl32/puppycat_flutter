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
      refreshToken: json['refreshToken'] as String,
      isSimple: json['isSimple'] as int,
      simpleType: json['simpleType'] as String,
      accessToken: json['accessToken'] as String,
      password: json['password'] as String,
      passwordConfirm: json['passwordConfirm'] as String,
      partner: json['partner'] as String? ?? '',
      ci: json['ci'] as String?,
      di: json['di'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      birth: json['birth'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'loginStatus': _$LoginStatusEnumMap[instance.loginStatus]!,
      'idx': instance.idx,
      'appKey': instance.appKey,
      'nick': instance.nick,
      'id': instance.id,
      'simpleId': instance.simpleId,
      'refreshToken': instance.refreshToken,
      'isSimple': instance.isSimple,
      'simpleType': instance.simpleType,
      'accessToken': instance.accessToken,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
      'partner': instance.partner,
      'ci': instance.ci,
      'di': instance.di,
      'name': instance.name,
      'phone': instance.phone,
      'birth': instance.birth,
      'gender': instance.gender,
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
