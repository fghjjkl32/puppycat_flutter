// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PolicyItemModel _$$_PolicyItemModelFromJson(Map<String, dynamic> json) =>
    _$_PolicyItemModel(
      idx: json['idx'] as int,
      required: json['required'] as String,
      detail: json['detail'] as String?,
      title: json['title'] as String?,
      isAgreed: json['isAgreed'] as bool? ?? false,
    );

Map<String, dynamic> _$$_PolicyItemModelToJson(_$_PolicyItemModel instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'required': instance.required,
      'detail': instance.detail,
      'title': instance.title,
      'isAgreed': instance.isAgreed,
    };
