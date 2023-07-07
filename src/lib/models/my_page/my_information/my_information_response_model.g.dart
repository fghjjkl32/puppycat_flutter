// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_information_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MyInformationResponseModel _$$_MyInformationResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_MyInformationResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: DataListModel<MyInformationItemModel>.fromJson(
          json['data'] as Map<String, dynamic>,
          (value) =>
              MyInformationItemModel.fromJson(value as Map<String, dynamic>)),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_MyInformationResponseModelToJson(
        _$_MyInformationResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
