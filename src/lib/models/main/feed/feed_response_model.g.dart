// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedResponseModel _$$_FeedResponseModelFromJson(Map<String, dynamic> json) =>
    _$_FeedResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: FeedDataListModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_FeedResponseModelToJson(
        _$_FeedResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
