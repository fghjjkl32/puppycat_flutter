import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/post/select_post.dart';

part 'my_post_state.freezed.dart';
part 'my_post_state.g.dart';

@freezed
class MyPostState with _$MyPostState {
  factory MyPostState({
    required SelectPost myPostState,
    required SelectPost myKeepState,
  }) = _MyPostState;

  factory MyPostState.fromJson(Map<String, dynamic> json) => _$MyPostStateFromJson(json);
}
