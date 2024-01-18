import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/feed/feed_repository.dart';
import 'package:riverpod/riverpod.dart';

final feedSearchStateProvider = StateNotifierProvider<FeedSearchStateNotifier, ContentDataListModel>((ref) {
  return FeedSearchStateNotifier(ref);
});

class FeedSearchStateNotifier extends StateNotifier<ContentDataListModel> {
  FeedSearchStateNotifier(this.ref) : super(const ContentDataListModel());

  int maxPages = 1;
  int currentPage = 1;

  final Ref ref;

  final Map<String, ContentDataListModel> searchStateMap = {};

  void getStateForContent(String searchWord) {
    state = searchStateMap[searchWord] ?? const ContentDataListModel();
  }

  initPosts(
    int? initPage,
    String searchWord,
  ) async {
    currentPage = 1;

    try {
      final page = initPage ?? state.page;
      final lists = await FeedRepository(dio: ref.read(dioProvider)).getUserHashtagContentList(page: page, searchWord: searchWord);

      maxPages = lists.params!.pagination?.endPage ?? 0;

      state = state.copyWith(totalCount: lists.params!.pagination?.totalRecordCount! ?? 0);

      if (lists == null) {
        state = state.copyWith(page: page, isLoading: false);
        return;
      }

      state = state.copyWith(
        page: page,
        isLoading: false,
        list: lists.list,
        totalCnt: lists.totalCnt,
      );

      searchStateMap[searchWord ?? ""] = state.copyWith(
        page: page,
        isLoading: false,
        list: lists.list,
        totalCnt: lists.totalCnt,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('feed search init error $e');
    }
  }

  loadMorePost(searchWord) async {
    if (currentPage >= maxPages) {
      state = state.copyWith(isLoadMoreDone: true);
      return;
    }

    StringBuffer bf = StringBuffer();

    try {
      bf.write('try to request loading ${state.isLoading} at ${state.page + 1}');
      if (state.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');
      state = state.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

      final lists = await FeedRepository(dio: ref.read(dioProvider)).getUserHashtagContentList(page: state.page + 1, searchWord: searchWord);

      if (lists == null) {
        state = state.copyWith(isLoadMoreError: true, isLoading: false);
        return;
      }

      if (lists.list.isNotEmpty) {
        state = state.copyWith(page: state.page + 1, isLoading: false, list: [...state.list, ...lists.list]);
        currentPage++;
      } else {
        state = state.copyWith(
          isLoading: false,
        );
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('feed search loadMorePost error $e');
    }
  }

  Future<void> refresh(searchWord) async {
    initPosts(1, searchWord);
    currentPage = 1;
  }
}
