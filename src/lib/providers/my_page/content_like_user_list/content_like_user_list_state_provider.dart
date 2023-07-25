import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/content_like_user_list/content_like_user_list_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/follow/follow_repository.dart';
import 'package:riverpod/riverpod.dart';

final contentLikeUserListStateProvider = StateNotifierProvider<
    ContentLikeUserListStateNotifier, ContentLikeUserListDataListModel>((ref) {
  return ContentLikeUserListStateNotifier();
});

class ContentLikeUserListStateNotifier
    extends StateNotifier<ContentLikeUserListDataListModel> {
  ContentLikeUserListStateNotifier()
      : super(const ContentLikeUserListDataListModel());

  int maxPages = 1;
  int currentPage = 1;
  initContentLikeUserList([
    contentsIdx,
    memberIdx,
    int? initPage,
  ]) async {
    print(contentsIdx);
    print(contentsIdx);
    print(contentsIdx);
    print(contentsIdx);
    print(contentsIdx);

    currentPage = 1;

    final page = initPage ?? state.page;
    final lists = await ContentLikeUserListRepository().getContentLikeUserList(
      contentsIdx: contentsIdx,
      memberIdx: memberIdx,
      page: page,
    );

    maxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        totalCount: lists.data.params!.pagination!.totalRecordCount!);

    if (lists == null) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }

    state = state.copyWith(page: page, isLoading: false, list: lists.data.list);
  }

  loadMoreContentLikeUserList(contentsIdx, memberIdx) async {
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

    final lists = await ContentLikeUserListRepository().getContentLikeUserList(
        contentsIdx: contentsIdx, memberIdx: memberIdx, page: state.page + 1);

    if (lists == null) {
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
      return;
    }

    if (lists.data.list.isNotEmpty) {
      state = state.copyWith(
          page: state.page + 1,
          isLoading: false,
          list: [...state.list, ...lists.data.list]);

      currentPage++;
    } else {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  Future<void> refresh(contentsIdx) async {
    initContentLikeUserList(contentsIdx, 1);
    currentPage = 1;
  }

  Future<ResponseModel> postFollow({
    required memberIdx,
    required followIdx,
    required contentsIdx,
  }) async {
    final result = await FollowRepository()
        .postFollow(memberIdx: memberIdx, followIdx: followIdx);

    refresh(contentsIdx);
    return result;
  }

  Future<ResponseModel> deleteFollow({
    required memberIdx,
    required followIdx,
    required contentsIdx,
  }) async {
    final result = await FollowRepository()
        .deleteFollow(memberIdx: memberIdx, followIdx: followIdx);

    refresh(contentsIdx);

    return result;
  }
}
