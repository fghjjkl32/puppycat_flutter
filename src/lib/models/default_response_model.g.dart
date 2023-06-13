// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ResponseModel _$$_ResponseModelFromJson(Map<String, dynamic> json) =>
    _$_ResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$$_ResponseModelToJson(_$_ResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'message': instance.message,
    };
