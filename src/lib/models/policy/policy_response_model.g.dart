// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PolicyResponseModel _$$_PolicyResponseModelFromJson(
        Map<String, dynamic> json) =>
    _$_PolicyResponseModel(
      result: json['result'] as bool,
      code: json['code'] as String,
      data: DataListModel<PolicyItemModel>.fromJson(
          json['data'] as Map<String, dynamic>,
          (value) => PolicyItemModel.fromJson(value as Map<String, dynamic>)),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_PolicyResponseModelToJson(
        _$_PolicyResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };
