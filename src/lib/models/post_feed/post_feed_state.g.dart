// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_feed_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostFeedState _$$_PostFeedStateFromJson(Map<String, dynamic> json) =>
    _$_PostFeedState(
      tagList: (json['tagList'] as List<dynamic>?)
              ?.map((e) =>
                  const OffsetConverter().fromJson(e as Map<String, double>))
              .toList() ??
          const [],
      tagImage: (json['tagImage'] as List<dynamic>?)
              ?.map((e) => TagImages.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      offsetCount: json['offsetCount'] as int? ?? 0,
    );

Map<String, dynamic> _$$_PostFeedStateToJson(_$_PostFeedState instance) =>
    <String, dynamic>{
      'tagList': instance.tagList.map(const OffsetConverter().toJson).toList(),
      'tagImage': instance.tagImage,
      'offsetCount': instance.offsetCount,
    };
