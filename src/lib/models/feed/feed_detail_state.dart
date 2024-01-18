import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data_list_model.dart';

part 'feed_detail_state.freezed.dart';
part 'feed_detail_state.g.dart';

@freezed
class FeedDetailState with _$FeedDetailState {
  factory FeedDetailState({
    required FeedDataListModel firstFeedState,
    required FeedDataListModel feedListState,
  }) = _FeedDetailState;

  factory FeedDetailState.fromJson(Map<String, dynamic> json) => _$FeedDetailStateFromJson(json);
}
