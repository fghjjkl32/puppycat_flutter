import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

final searchStateProvider =
    StateNotifierProvider<SearchStateNotifier, SearchDataListModel>((ref) {
  final loginMemberIdx = ref.watch(userModelProvider)!.idx;
  return SearchStateNotifier(loginMemberIdx);
});

class SearchStateNotifier extends StateNotifier<SearchDataListModel> {
  final int loginMemberIdx;

  SearchStateNotifier(this.loginMemberIdx)
      : super(const SearchDataListModel()) {
    searchQuery.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((query) async {
      await searchMentionList(query);
    });
  }

  int recommendMaxPages = 1;
  int searchMentionMaxPages = 1;

  bool isMentionSearching = false;

  String searchSearchWord = '';
  int searchMentionCurrentPage = 1;
  int recommendCurrentPage = 1;

  getMentionRecommendList({required int? initPage}) async {
    recommendCurrentPage = 1;

    final page = initPage ?? state.page;
    final lists = await SearchRepository().getMentionRecommendList(
      memberIdx: loginMemberIdx,
      page: page,
    );

    recommendMaxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        totalCount: lists.data.params!.pagination!.totalRecordCount!);

    if (lists == null) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }

    state = state.copyWith(page: page, isLoading: false, list: lists.data.list);
  }

  loadMoreMentionSearchList(memberIdx) async {
    if (isMentionSearching) {
      if (searchMentionCurrentPage >= searchMentionMaxPages) {
        state = state.copyWith(isLoadMoreDone: true);
        return;
      }

      StringBuffer bf = StringBuffer();

      bf.write(
          'try to request loading ${state.isLoading} at ${state.page + 1}');
      if (state.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(
          isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

      final lists = await SearchRepository().getSearchList(
        memberIdx: memberIdx,
        page: recommendCurrentPage + 1,
        searchWord: searchSearchWord,
      );

      if (lists == null) {
        state = state.copyWith(isLoadMoreError: true, isLoading: false);
        return;
      }

      if (lists.data.list.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          list: [...state.list, ...lists.data.list],
        );
        searchMentionCurrentPage++;
      } else {
        state = state.copyWith(isLoading: false);
      }
    } else {
      if (recommendCurrentPage >= recommendMaxPages) {
        state = state.copyWith(isLoadMoreDone: true);
        return;
      }

      StringBuffer bf = StringBuffer();

      bf.write(
          'try to request loading ${state.isLoading} at ${state.page + 1}');
      if (state.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(
          isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

      final lists = await SearchRepository().getMentionRecommendList(
        memberIdx: memberIdx,
        page: recommendCurrentPage + 1,
      );

      if (lists == null) {
        state = state.copyWith(isLoadMoreError: true, isLoading: false);
        return;
      }

      if (lists.data.list.isNotEmpty) {
        state = state.copyWith(
            page: state.page + 1,
            isLoading: false,
            list: [...state.list, ...lists.data.list]);
        recommendCurrentPage++;
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  final searchQuery = PublishSubject<String>();

  Future<void> searchMentionList(String searchWord) async {
    searchSearchWord = searchWord;
    searchMentionCurrentPage = 1;
    isMentionSearching = true;

    final lists = await SearchRepository().getSearchList(
      memberIdx: loginMemberIdx,
      page: 1,
      searchWord: searchSearchWord,
    );

    searchMentionMaxPages = lists.data.params!.pagination!.endPage!;

    if (lists == null) {
      state = state.copyWith(page: 1, isLoading: false, list: []);
      return;
    }

    state = state.copyWith(page: 1, isLoading: false, list: lists.data.list);
  }

  @override
  void dispose() {
    searchQuery.close();
    super.dispose();
  }
}
