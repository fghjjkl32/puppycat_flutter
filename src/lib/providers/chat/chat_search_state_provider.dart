import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_search_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ChatUserSearchState extends _$ChatUserSearchState {
  String _searchWord = '';
  int _lastPage = 0;

  @override
  PagingController<int, SearchData> build() {
    PagingController<int, SearchData> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_searchWord.isEmpty || _searchWord == '') {
        state.itemList = [];
        return;
      }

      var searchResult = await SearchRepository(dio: ref.read(dioProvider)).getNickSearchList(
        page: pageKey,
        searchWord: _searchWord,
      );

      var searchList = searchResult.list;

      try {
        _lastPage = searchResult.params!.pagination?.totalPageCount! ?? 0;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state.error = apiException.toString();
    } catch (e) {
      state.error = e;
    }
  }

  void searchUser(String searchWord) {
    if (searchWord.isEmpty || searchWord == '') {
      state.itemList = [];
      return;
    }

    _searchWord = searchWord;

    state.refresh();
  }
}
