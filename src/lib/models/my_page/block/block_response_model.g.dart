// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BlockResponseModel _$$_BlockResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_BlockResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: BlockDataListModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_BlockResponseModelToJson(
        _$_BlockResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
