import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/content_like_user_list/content_like_user_list_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/follow/follow_repository.dart';
import 'package:riverpod/riverpod.dart';

final contentLikeUserListStateProvider = StateNotifierProvider<ContentLikeUserListStateNotifier, ContentLikeUserListDataListModel>((ref) {
  return ContentLikeUserListStateNotifier(ref);
});

class ContentLikeUserListStateNotifier extends StateNotifier<ContentLikeUserListDataListModel> {
  ContentLikeUserListStateNotifier(this.ref) : super(const ContentLikeUserListDataListModel());

  int maxPages = 1;
  int currentPage = 1;

  final Ref ref;

  initContentLikeUserList([
    contentsIdx,
    memberIdx,
    int? initPage,
  ]) async {
    currentPage = 1;

    final page = initPage ?? state.page;
    final lists = await ContentLikeUserListRepository(dio: ref.read(dioProvider)).getContentLikeUserList(
      contentsIdx: contentsIdx,
      memberIdx: memberIdx,
      page: page,
    );

    maxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(totalCount: lists.data.params!.pagination!.totalRecordCount!);

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
    state = state.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

    final lists = await ContentLikeUserListRepository(dio: ref.read(dioProvider)).getContentLikeUserList(contentsIdx: contentsIdx, memberIdx: memberIdx, page: state.page + 1);

    if (lists == null) {
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
      return;
    }

    if (lists.data.list.isNotEmpty) {
      state = state.copyWith(page: state.page + 1, isLoading: false, list: [...state.list, ...lists.data.list]);

      currentPage++;
    } else {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  // Future<void> refresh(contentsIdx, memberIdx) async {
  //   initContentLikeUserList(contentsIdx, memberIdx, 1);
  //   currentPage = 1;
  // }

  // Future<ResponseModel> postFollow({
  //   required memberIdx,
  //   required followIdx,
  //   required contentsIdx,
  // }) async {
  //   final result = await FollowRepository(dio: ref.read(dioProvider))
  //       .postFollow(memberIdx: memberIdx, followIdx: followIdx);
  //
  //   refresh(contentsIdx, memberIdx);
  //   return result;
  // }
  //
  // Future<ResponseModel> deleteFollow({
  //   required memberIdx,
  //   required followIdx,
  //   required contentsIdx,
  // }) async {
  //   final result = await FollowRepository(dio: ref.read(dioProvider))
  //       .deleteFollow(memberIdx: memberIdx, followIdx: followIdx);
  //
  //   refresh(contentsIdx, memberIdx);
  //
  //   return result;
  // }
}
