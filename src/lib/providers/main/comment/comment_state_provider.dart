import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/main/comment/comment_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/user_contents/user_contents_repository.dart';
import 'package:riverpod/riverpod.dart';

final commentStateProvider =
    StateNotifierProvider<CommentStateNotifier, CommentDataListModel>((ref) {
  return CommentStateNotifier();
});

class CommentStateNotifier extends StateNotifier<CommentDataListModel> {
  CommentStateNotifier() : super(const CommentDataListModel());

  int maxPages = 1;
  int currentPage = 1;
  initPosts([
    contentIdx,
    int? initPage,
  ]) async {
    currentPage = 1;

    final page = initPage ?? state.page;
    final lists = await CommentRepository()
        .getComment(page: page, contentIdx: contentIdx);

    maxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        totalCount: lists.data.params!.pagination!.totalRecordCount!);

    if (lists == null) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }

    state = state.copyWith(page: page, isLoading: false, list: lists.data.list);
  }

  loadMoreComment(contentIdx) async {
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

    final lists = await CommentRepository()
        .getComment(contentIdx: contentIdx, page: state.page + 1);

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
    initPosts(contentsIdx, 1);
    currentPage = 1;
  }

  Future<ResponseModel> deleteContents(
      {required memberIdx, required contentsIdx, required commentIdx}) async {
    final result = await CommentRepository().deleteComment(
      memberIdx: memberIdx,
      contentsIdx: contentsIdx,
      commentIdx: commentIdx,
    );

    await refresh(contentsIdx);

    return result;
  }

  Future<ResponseModel> postContents({
    required memberIdx,
    required contents,
    required contentIdx,
    int? parentIdx,
  }) async {
    final result = await CommentRepository().postComment(
        memberIdx: memberIdx,
        contents: contents,
        parentIdx: parentIdx,
        contentIdx: contentIdx);

    await refresh(contentIdx);

    return result;
  }
}
