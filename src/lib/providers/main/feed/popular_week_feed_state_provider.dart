import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod/riverpod.dart';

final popularWeekFeedStateProvider =
    StateNotifierProvider<PopularWeekFeedStateNotifier, FeedDataListModel>(
        (ref) {
  return PopularWeekFeedStateNotifier(ref);
});

class PopularWeekFeedStateNotifier extends StateNotifier<FeedDataListModel> {
  PopularWeekFeedStateNotifier(this.ref) : super(const FeedDataListModel());

  final Ref ref;

  int maxPages = 1;
  int currentPage = 1;
  initPosts({
    required loginMemberIdx,
    required int? initPage,
  }) async {
    currentPage = 1;

    final page = initPage ?? state.page;
    final lists = await FeedRepository(dio: ref.read(dioProvider)).getPopularWeekDetailList(
      loginMemberIdx: loginMemberIdx,
      page: page,
    );
    maxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        totalCount: lists.data.params!.pagination!.totalRecordCount!);

    if (lists == null) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }

    state = state.copyWith(
      page: page,
      isLoading: false,
      list: lists.data.list,
      memberInfo: lists.data.memberInfo,
      imgDomain: lists.data.imgDomain,
    );
  }

  loadMorePost({required loginMemberIdx}) async {
    if (currentPage >= maxPages) {
      state = state.copyWith(isLoadMoreDone: true);
      return;
    }

    StringBuffer bf = StringBuffer();

    bf.write('try to request loading ${state.isLoading} at ${state.page + 1}');
    if (state.isLoading) {
      bf.write(' fail');
      return;
    }
    bf.write(' success');
    state = state.copyWith(
        isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

    final lists = await FeedRepository(dio: ref.read(dioProvider)).getPopularWeekDetailList(
      loginMemberIdx: loginMemberIdx,
      page: state.page + 1,
    );

    if (lists == null) {
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
      return;
    }

    if (lists.data.list.isNotEmpty) {
      state = state.copyWith(
        page: state.page + 1,
        isLoading: false,
        list: [...state.list, ...lists.data.list],
        memberInfo: [...?state.memberInfo, ...?lists.data.memberInfo],
        imgDomain: lists.data.imgDomain,
      );

      currentPage++;
    } else {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  Future<void> refresh(loginMemberIdx) async {
    initPosts(loginMemberIdx: loginMemberIdx, initPage: 1);
    currentPage = 1;
  }

  void updateState(FeedDataListModel newState) {
    state = newState;
  }
}
