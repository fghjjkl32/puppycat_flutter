import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/select_post.dart';

part 'follow_state.freezed.dart';

part 'follow_state.g.dart';

@freezed
class FollowState with _$FollowState {
  factory FollowState({
    required FollowDataListModel followerListState,
    required FollowDataListModel followListState,
  }) = _FollowState;

  factory FollowState.fromJson(Map<String, dynamic> json) =>
      _$FollowStateFromJson(json);
}
