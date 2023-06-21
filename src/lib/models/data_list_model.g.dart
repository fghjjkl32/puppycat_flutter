// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataListModel<T> _$DataListModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    DataListModel<T>(
      list: (json['list'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$DataListModelToJson<T>(
  DataListModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'list': instance.list.map(toJsonT).toList(),
    };
