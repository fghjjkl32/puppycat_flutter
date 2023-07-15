// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_data_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommentDataListModel _$$_CommentDataListModelFromJson(
        Map<String, dynamic> json) =>
    _$_CommentDataListModel(
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => CommentData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      params: json['params'] == null
          ? null
          : ParamsModel.fromJson(json['params'] as Map<String, dynamic>),
      page: json['page'] as int? ?? 1,
      isLoading: json['isLoading'] as bool? ?? true,
      isLoadMoreError: json['isLoadMoreError'] as bool? ?? false,
      isLoadMoreDone: json['isLoadMoreDone'] as bool? ?? false,
      totalCount: json['totalCount'] as int? ?? 0,
    );

Map<String, dynamic> _$$_CommentDataListModelToJson(
        _$_CommentDataListModel instance) =>
    <String, dynamic>{
      'list': instance.list,
      'params': instance.params,
      'page': instance.page,
      'isLoading': instance.isLoading,
      'isLoadMoreError': instance.isLoadMoreError,
      'isLoadMoreDone': instance.isLoadMoreDone,
      'totalCount': instance.totalCount,
    };
