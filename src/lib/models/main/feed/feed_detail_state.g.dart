// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_detail_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedDetailState _$$_FeedDetailStateFromJson(Map<String, dynamic> json) =>
    _$_FeedDetailState(
      firstFeedState: FeedDataListModel.fromJson(
          json['firstFeedState'] as Map<String, dynamic>),
      feedListState: FeedDataListModel.fromJson(
          json['feedListState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_FeedDetailStateToJson(_$_FeedDetailState instance) =>
    <String, dynamic>{
      'firstFeedState': instance.firstFeedState,
      'feedListState': instance.feedListState,
    };
