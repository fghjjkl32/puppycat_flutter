import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod/riverpod.dart';

final popularHourFeedStateProvider =
    StateNotifierProvider<PopularHourFeedStateNotifier, FeedDataListModel>(
        (ref) {
  return PopularHourFeedStateNotifier(ref);
});

class PopularHourFeedStateNotifier extends StateNotifier<FeedDataListModel> {
  PopularHourFeedStateNotifier(this.ref) : super(const FeedDataListModel());

  final Ref ref;

  initPosts({
    required loginMemberIdx,
  }) async {
    final lists = await FeedRepository(dio: ref.read(dioProvider)).getPopularHourDetailList(
      loginMemberIdx: loginMemberIdx,
      page: 1,
    );
    state = state.copyWith(
        totalCount: lists.data.params!.pagination!.totalRecordCount!);

    if (lists == null) {
      state = state.copyWith(page: 1, isLoading: false);
      return;
    }

    state = state.copyWith(
      page: 1,
      isLoading: false,
      list: lists.data.list,
      memberInfo: lists.data.memberInfo,
      imgDomain: lists.data.imgDomain,
    );
  }
}
