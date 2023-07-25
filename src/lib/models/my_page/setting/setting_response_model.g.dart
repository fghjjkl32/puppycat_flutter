// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SettingResponseModel _$$_SettingResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_SettingResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: SettingDataListModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_SettingResponseModelToJson(
        _$_SettingResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
