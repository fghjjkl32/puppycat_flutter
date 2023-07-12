// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_post_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MyPostState _$$_MyPostStateFromJson(Map<String, dynamic> json) =>
    _$_MyPostState(
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => ContentImageData.fromJson(e as Map<String, dynamic>))
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
      selectOrder: (json['selectOrder'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      currentOrder: json['currentOrder'] as int? ?? 1,
    );

Map<String, dynamic> _$$_MyPostStateToJson(_$_MyPostState instance) =>
    <String, dynamic>{
      'list': instance.list,
      'params': instance.params,
      'page': instance.page,
      'isLoading': instance.isLoading,
      'isLoadMoreError': instance.isLoadMoreError,
      'isLoadMoreDone': instance.isLoadMoreDone,
      'totalCount': instance.totalCount,
      'selectOrder': instance.selectOrder,
      'currentOrder': instance.currentOrder,
    };
