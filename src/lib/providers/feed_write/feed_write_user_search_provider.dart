import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

final feedWriteImageTagSearchProvider = StateNotifierProvider<FeedWriteImageTagSearchNotifier, SearchDataListModel>((ref) {
  return FeedWriteImageTagSearchNotifier(ref);
});

class FeedWriteImageTagSearchNotifier extends StateNotifier<SearchDataListModel> {
  final Ref ref;

  FeedWriteImageTagSearchNotifier(this.ref) : super(const SearchDataListModel()) {
    userSearchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchUserList(query);
    });
  }

  final userSearchQuery = PublishSubject<String>();

  int imageTagMaxPages = 1;
  int imageTagCurrentPage = 1;

  bool isSearching = false;
  String userSearchWord = '';
  int searchUserMaxPages = 1;
  int searchUserCurrentPage = 1;

  initImageTagUserList([int? initPage]) async {
    imageTagCurrentPage = 1;

    try {
      final page = initPage ?? state.page;
      final lists = await SearchRepository(dio: ref.read(dioProvider)).getImageTagRecommendList(
        page: page,
      );

      imageTagMaxPages = lists.params!.pagination?.endPage ?? 0;

      state = state.copyWith(totalCount: lists.params!.pagination?.totalRecordCount! ?? 0);

      if (lists == null) {
        state = state.copyWith(page: page, isLoading: false);
        return;
      }

      state = state.copyWith(page: page, isLoading: false, list: lists.list);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(page: state.page, isLoading: false);
    } catch (e) {
      userSearchQuery.add("");

      print('initImageTagUserList error $e');
      state = state.copyWith(page: state.page, isLoading: false);
    }
  }

  loadMoreUserList() async {
    try {
      if (isSearching) {
        if (searchUserCurrentPage >= imageTagMaxPages) {
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

        final lists = await SearchRepository(dio: ref.read(dioProvider)).getNickSearchList(
          page: searchUserCurrentPage + 1,
          searchWord: userSearchWord,
        );

        if (lists == null) {
          state = state.copyWith(isLoadMoreError: true, isLoading: false);
          return;
        }

        if (lists.list.isNotEmpty) {
          state = state.copyWith(
            isLoading: false,
            list: [...state.list, ...lists.list],
          );
          searchUserCurrentPage++;
        } else {
          state = state.copyWith(isLoading: false);
        }
      } else {
        if (imageTagCurrentPage >= imageTagMaxPages) {
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

        final lists = await SearchRepository(dio: ref.read(dioProvider)).getImageTagRecommendList(
          page: state.page + 1,
        );

        if (lists == null) {
          state = state.copyWith(isLoadMoreError: true, isLoading: false);
          return;
        }

        if (lists.list.isNotEmpty) {
          state = state.copyWith(page: state.page + 1, isLoading: false, list: [...state.list, ...lists.list]);
          imageTagCurrentPage++;
        } else {
          state = state.copyWith(isLoading: false);
        }
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('loadMoreUserList error $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> searchUserList(String searchWord) async {
    userSearchWord = searchWord;
    isSearching = true;
    searchUserCurrentPage = 1;

    print("searchWord" "${searchWord}");

    try {
      final lists = await SearchRepository(dio: ref.read(dioProvider)).getNickSearchList(
        page: 1,
        searchWord: searchWord,
      );

      searchUserMaxPages = lists.params!.pagination?.endPage ?? 0;

      if (lists == null) {
        state = state.copyWith(page: 1, isLoading: false, list: []);
        return;
      }

      state = state.copyWith(page: 1, isLoading: false, list: lists.list);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(page: 1, isLoading: false, list: []);
    } catch (e) {
      print('searchUserList error $e');
      state = state.copyWith(page: 1, isLoading: false, list: []);
    }
  }

  @override
  void dispose() {
    userSearchQuery.close();
    super.dispose();
  }
}
