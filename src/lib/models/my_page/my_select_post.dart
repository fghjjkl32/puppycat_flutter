// FeedData

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'my_select_post.freezed.dart';

part 'my_select_post.g.dart';

@freezed
class MySelectPost with _$MySelectPost {
  factory MySelectPost({
    @Default([]) List<FeedData> list,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
    @Default([]) List<int> selectOrder,
    @Default(1) int currentOrder,
  }) = _MySelectPost;

  factory MySelectPost.fromJson(Map<String, dynamic> json) =>
      _$MySelectPostFromJson(json);
}
