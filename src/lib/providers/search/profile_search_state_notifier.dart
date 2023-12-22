import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

final profileSearchStateProvider = StateNotifierProvider<ProfileSearchStateNotifier, SearchDataListModel>((ref) {
  return ProfileSearchStateNotifier(ref);
});

class ProfileSearchStateNotifier extends StateNotifier<SearchDataListModel> {
  final Ref ref;

  ProfileSearchStateNotifier(this.ref) : super(const SearchDataListModel()) {
    searchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchTagList(query);
    });
  }

  int profileMaxPages = 1;

  String searchSearchWord = '';
  int searchProfileCurrentPage = 1;

  final searchQuery = PublishSubject<String>();

  Future<void> searchTagList(String searchWord) async {
    if (searchWord.isEmpty) {
      return;
    }

    searchSearchWord = searchWord;

    final lists = await SearchRepository(dio: ref.read(dioProvider)).getNickSearchList(
      searchWord: searchSearchWord,
      page: 1,
    );

    if (lists.list.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        best_list: lists.best_list,
        list: lists.list,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      list: lists.list,
    );
  }

  loadMoreNickSearchList() async {
    if (searchProfileCurrentPage >= profileMaxPages) {
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
      page: searchProfileCurrentPage + 1,
      searchWord: searchSearchWord,
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
      searchProfileCurrentPage++;
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    searchQuery.close();
    super.dispose();
  }
}
