import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

final fullSearchStateProvider =
    StateNotifierProvider<FullSearchStateNotifier, SearchDataListModel>((ref) {
  final loginMemberIdx = ref.watch(userModelProvider)!.idx;
  return FullSearchStateNotifier(loginMemberIdx);
});

class FullSearchStateNotifier extends StateNotifier<SearchDataListModel> {
  final int loginMemberIdx;

  FullSearchStateNotifier(this.loginMemberIdx)
      : super(const SearchDataListModel()) {
    searchQuery.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((query) async {
      await searchFullList(query);
    });
  }

  String searchSearchWord = '';

  final searchQuery = PublishSubject<String>();

  Future<void> searchFullList(String searchWord) async {
    searchSearchWord = searchWord;

    final lists = await SearchRepository().getFullSearchList(
      memberIdx: loginMemberIdx,
      searchWord: searchSearchWord,
    );

    if (lists.data.nick_list!.isEmpty && lists.data.nick_list!.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        best_list: lists.data.best_list,
        nick_list: lists.data.nick_list,
        tag_list: lists.data.tag_list,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      nick_list: lists.data.nick_list,
      tag_list: lists.data.tag_list,
    );
  }

  @override
  void dispose() {
    searchQuery.close();
    super.dispose();
  }
}
