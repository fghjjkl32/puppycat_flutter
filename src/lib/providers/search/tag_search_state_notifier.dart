import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

final tagSearchStateProvider = StateNotifierProvider<TagSearchStateNotifier, SearchDataListModel>((ref) {
  final loginMemberIdx = ref.watch(userInfoProvider).userModel?.idx;
  return TagSearchStateNotifier(loginMemberIdx, ref);
});

class TagSearchStateNotifier extends StateNotifier<SearchDataListModel> {
  final int? loginMemberIdx;
  final Ref ref;

  TagSearchStateNotifier(this.loginMemberIdx, this.ref) : super(const SearchDataListModel()) {
    searchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchTagList(query);
    });
  }

  int searchTagMaxPages = 1;

  String searchSearchWord = '';
  int searchTagCurrentPage = 1;

  final searchQuery = PublishSubject<String>();

  Future<void> searchTagList(String searchWord) async {
    searchSearchWord = searchWord;

    try {
      final lists = await SearchRepository(dio: ref.read(dioProvider)).getTagSearchList(
        memberIdx: loginMemberIdx,
        searchWord: searchSearchWord,
        page: 1,
      );

      if (lists.data.list.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          best_list: lists.data.best_list,
          list: lists.data.list,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        list: lists.data.list,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(
        isLoading: false,
        best_list: state.best_list,
        list: state.list,
      );
    } catch (e) {
      print('searchTagList error $e');
      state = state.copyWith(
        isLoading: false,
        best_list: state.best_list,
        list: state.list,
      );
    }
  }

  loadMoreTagSearchList(memberIdx) async {
    if (searchTagCurrentPage >= searchTagMaxPages) {
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

      final lists = await SearchRepository(dio: ref.read(dioProvider)).getTagSearchList(
        memberIdx: memberIdx,
        page: searchTagCurrentPage + 1,
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
        searchTagCurrentPage++;
      } else {
        state = state.copyWith(isLoading: false);
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
    } catch (e) {
      print('loadMoreTagSearchList error $e');
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
    }
  }

  @override
  void dispose() {
    searchQuery.close();
    super.dispose();
  }
}
