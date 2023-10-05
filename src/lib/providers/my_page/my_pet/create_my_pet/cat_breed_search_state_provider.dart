import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/item_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/create_my_pet/create_my_pet_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cat_breed_search_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CatBreedSearchState extends _$CatBreedSearchState {
  int _loginMemberIdx = 0;
  String _searchWord = '';
  int _lastPage = 0;

  @override
  PagingController<int, ItemModel> build() {
    PagingController<int, ItemModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var searchResult = await CreateMyPetRepository(dio: ref.read(dioProvider)).getBreedList(loginMemberIdx: _loginMemberIdx, page: pageKey, searchWord: _searchWord, limit: 20, type: 2);

      var searchList = searchResult.data.list
          .map(
            (e) => ItemModel(
              name: e.name,
              sort: e.sort,
              idx: e.idx,
            ),
          )
          .toList();

      try {
        _lastPage = searchResult.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }
    } catch (e) {
      state.error = e;
    }
  }

  void searchBreed(int memberIdx, String searchWord) {
    if (memberIdx < 0) {
      return;
    }
    _searchWord = searchWord;
    _loginMemberIdx = memberIdx;
    _searchWord = searchWord;

    state.refresh();
  }
}
