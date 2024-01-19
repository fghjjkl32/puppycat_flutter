import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';

final fullSearchStateProvider = StateNotifierProvider<FullSearchStateNotifier, SearchDataListModel>((ref) {
  return FullSearchStateNotifier(ref);
});

class FullSearchStateNotifier extends StateNotifier<SearchDataListModel> {
  final Ref ref;

  FullSearchStateNotifier(this.ref) : super(const SearchDataListModel()) {
    // searchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
    //   await searchFullList(query);
    // });
  }

  String searchSearchWord = '';

  // final searchQuery = PublishSubject<String>();

  Future<void> searchFullList(String searchWord) async {
    print(" searchWord ${searchWord}");
    if (searchWord.isEmpty) {
      return;
    }

    searchSearchWord = searchWord;

    final lists = await SearchRepository(dio: ref.read(dioProvider)).getFullSearchList(
      searchWord: searchSearchWord,
    );

    if (lists.nick_list!.isEmpty && lists.nick_list!.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        best_list: lists.best_list,
        nick_list: lists.nick_list,
        tag_list: lists.tag_list,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      nick_list: lists.nick_list,
      tag_list: lists.tag_list,
    );
  }

  @override
  void dispose() {
    // searchQuery.close();
    super.dispose();
  }
}
