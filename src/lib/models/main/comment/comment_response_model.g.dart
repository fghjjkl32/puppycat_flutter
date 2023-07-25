// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommentResponseModel _$$_CommentResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_CommentResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: CommentDataListModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_CommentResponseModelToJson(
        _$_CommentResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
