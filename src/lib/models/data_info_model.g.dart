// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataInfoModel<T> _$DataInfoModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    DataInfoModel<T>(
      info: (json['info'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$DataInfoModelToJson<T>(
  DataInfoModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'info': instance.info.map(toJsonT).toList(),
    };
