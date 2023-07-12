// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserInformationResponseModel _$$_UserInformationResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_UserInformationResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: DataInfoModel<UserInformationItemModel>.fromJson(
          json['data'] as Map<String, dynamic>,
          (value) =>
              UserInformationItemModel.fromJson(value as Map<String, dynamic>)),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_UserInformationResponseModelToJson(
        _$_UserInformationResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
