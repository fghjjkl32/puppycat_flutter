import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/common/converter/offset_converter.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag_images.dart';

part 'post_feed_state.freezed.dart';
part 'post_feed_state.g.dart';

@freezed
class PostFeedState with _$PostFeedState {
  @OffsetConverter()
  factory PostFeedState({
    @Default([]) List<Offset> tagList,
    @Default([]) List<TagImages> tagImage,
    @Default(0) int offsetCount,
    @Default([]) List<TagImages> initialTagList,
  }) = _PostFeedState;

  factory PostFeedState.fromJson(Map<String, dynamic> json) => _$PostFeedStateFromJson(json);
}
