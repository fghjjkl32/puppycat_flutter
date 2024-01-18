import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_image_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'select_post.freezed.dart';

part 'select_post.g.dart';

@freezed
class SelectPost with _$SelectPost {
  factory SelectPost({
    @Default([]) List<ContentImageData> list,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
    @Default([]) List<int> selectOrder,
    @Default(1) int currentOrder,
  }) = _SelectPost;

  factory SelectPost.fromJson(Map<String, dynamic> json) => _$SelectPostFromJson(json);
}
