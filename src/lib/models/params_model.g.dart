// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ParamsModel _$$_ParamsModelFromJson(Map<String, dynamic> json) =>
    _$_ParamsModel(
      memberIdx: json['memberIdx'] as int?,
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      offset: json['offset'] as int?,
      limit: json['limit'] as int?,
      pageSize: json['pageSize'] as int?,
      page: json['page'] as int?,
      recordSize: json['recordSize'] as int?,
    );

Map<String, dynamic> _$$_ParamsModelToJson(_$_ParamsModel instance) =>
    <String, dynamic>{
      'memberIdx': instance.memberIdx,
      'pagination': instance.pagination,
      'offset': instance.offset,
      'limit': instance.limit,
      'pageSize': instance.pageSize,
      'page': instance.page,
      'recordSize': instance.recordSize,
    };

_$_Pagination _$$_PaginationFromJson(Map<String, dynamic> json) =>
    _$_Pagination(
      startPage: json['startPage'] as int?,
      limitStart: json['limitStart'] as int?,
      totalPageCount: json['totalPageCount'] as int?,
      existNextPage: json['existNextPage'] as bool?,
      endPage: json['endPage'] as int?,
      existPrevPage: json['existPrevPage'] as bool?,
      totalRecordCount: json['totalRecordCount'] as int?,
    );

Map<String, dynamic> _$$_PaginationToJson(_$_Pagination instance) =>
    <String, dynamic>{
      'startPage': instance.startPage,
      'limitStart': instance.limitStart,
      'totalPageCount': instance.totalPageCount,
      'existNextPage': instance.existNextPage,
      'endPage': instance.endPage,
      'existPrevPage': instance.existPrevPage,
      'totalRecordCount': instance.totalRecordCount,
    };
