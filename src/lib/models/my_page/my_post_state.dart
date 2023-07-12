import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'my_post_state.freezed.dart';

part 'my_post_state.g.dart';

@freezed
class MyPostState with _$MyPostState {
  factory MyPostState({
    @Default([]) List<ContentImageData> list,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
    @Default([]) List<int> selectOrder, // 추가
    @Default(1) int currentOrder,
  }) = _MyPostState;

  factory MyPostState.fromJson(Map<String, dynamic> json) =>
      _$MyPostStateFromJson(json);
}
