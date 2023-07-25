// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FollowResponseModel _$$_FollowResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_FollowResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: FollowDataListModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_FollowResponseModelToJson(
        _$_FollowResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
