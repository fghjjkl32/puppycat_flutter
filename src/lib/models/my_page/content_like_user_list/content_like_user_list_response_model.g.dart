// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_like_user_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ContentLikeUserListResponseModel
    _$$_ContentLikeUserListResponseModelFromJson(Map<String, dynamic> json) =>
        _$_ContentLikeUserListResponseModel(
          result: json['result'] as bool,
          code: json['code'] as String,
          data: ContentLikeUserListDataListModel.fromJson(
              json['data'] as Map<String, dynamic>),
          message: json['message'] as String?,
        );

Map<String, dynamic> _$$_ContentLikeUserListResponseModelToJson(
        _$_ContentLikeUserListResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
