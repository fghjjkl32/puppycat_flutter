// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_favorite_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatFavoriteResponseModel _$$_ChatFavoriteResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_ChatFavoriteResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: DataListModel<ChatFavoriteModel>.fromJson(
          json['data'] as Map<String, dynamic>,
          (value) => ChatFavoriteModel.fromJson(value as Map<String, dynamic>)),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_ChatFavoriteResponseModelToJson(
        _$_ChatFavoriteResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
