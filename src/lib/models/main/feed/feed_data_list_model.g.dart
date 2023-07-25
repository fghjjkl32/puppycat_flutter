// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_data_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedDataListModel _$$_FeedDataListModelFromJson(Map<String, dynamic> json) =>
    _$_FeedDataListModel(
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => FeedData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      memberInfo: (json['memberInfo'] as List<dynamic>?)
          ?.map(
              (e) => FeedMemberInfoListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      imgDomain: json['imgDomain'] as String?,
      params: json['params'] == null
          ? null
          : ParamsModel.fromJson(json['params'] as Map<String, dynamic>),
      page: json['page'] as int? ?? 1,
      isLoading: json['isLoading'] as bool? ?? true,
      isLoadMoreError: json['isLoadMoreError'] as bool? ?? false,
      isLoadMoreDone: json['isLoadMoreDone'] as bool? ?? false,
      totalCount: json['totalCount'] as int? ?? 0,
    );

Map<String, dynamic> _$$_FeedDataListModelToJson(
        _$_FeedDataListModel instance) =>
    <String, dynamic>{
      'list': instance.list,
      'memberInfo': instance.memberInfo,
      'imgDomain': instance.imgDomain,
      'params': instance.params,
      'page': instance.page,
      'isLoading': instance.isLoading,
      'isLoadMoreError': instance.isLoadMoreError,
      'isLoadMoreDone': instance.isLoadMoreDone,
      'totalCount': instance.totalCount,
    };
