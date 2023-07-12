// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ContentResponseModel _$$_ContentResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_ContentResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: ContentDataListModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_ContentResponseModelToJson(
        _$_ContentResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
