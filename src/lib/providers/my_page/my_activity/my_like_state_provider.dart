import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/like_contents/like_contents_repository.dart';
import 'package:riverpod/riverpod.dart';

final myLikeStateProvider = StateNotifierProvider<MyLikeStateNotifier, ContentDataListModel>((ref) {
  return MyLikeStateNotifier(ref);
});

class MyLikeStateNotifier extends StateNotifier<ContentDataListModel> {
  MyLikeStateNotifier(this.ref) : super(const ContentDataListModel());

  int maxPages = 1;
  int currentPage = 1;

  final Ref ref;

  initPosts([
    int? initPage,
  ]) async {
    currentPage = 1;

    try {
      final page = initPage ?? state.page;
      final lists = await LikeContentsRepository(dio: ref.read(dioProvider)).getLikeContents(page: page);

      maxPages = lists.data.params!.pagination?.endPage ?? 0;

      state = state.copyWith(totalCount: lists.data.params!.pagination?.totalRecordCount! ?? 0);

      if (lists == null) {
        state = state.copyWith(page: page, isLoading: false);
        return;
      }

      state = state.copyWith(page: page, isLoading: false, list: lists.data.list);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('initPosts error $e');
    }
  }

  loadMorePost() async {
    if (currentPage >= maxPages) {
      state = state.copyWith(isLoadMoreDone: true);
      return;
    }

    try {
      StringBuffer bf = StringBuffer();

      bf.write('try to request loading ${state.isLoading} at ${state.page + 1}');
      if (state.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');
      state = state.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

      final lists = await LikeContentsRepository(dio: ref.read(dioProvider)).getLikeContents(page: state.page + 1);

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
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('loadMorePost error $e');
    }
  }

  Future<void> refresh() async {
    initPosts(1);
    currentPage = 1;
  }
}
