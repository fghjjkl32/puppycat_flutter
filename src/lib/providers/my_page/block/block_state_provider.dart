import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/block/block_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_state.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/follow/follow_repository.dart';
import 'package:rxdart/rxdart.dart';

final blockStateProvider =
    StateNotifierProvider<BlockStateNotifier, BlockDataListModel>((ref) {
  final loginMemberIdx = ref.watch(userModelProvider)!.idx;
  return BlockStateNotifier(loginMemberIdx);
});

class BlockStateNotifier extends StateNotifier<BlockDataListModel> {
  final int loginMemberIdx;

  BlockStateNotifier(this.loginMemberIdx) : super(const BlockDataListModel()) {
    blockSearchQuery.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((query) async {
      await searchBlockList(query);
    });
  }

  int userMemberIdx = 0;

  int blockMaxPages = 1;
  int blockCurrentPage = 1;

  bool isBlockSearching = false;
  String blockSearchWord = '';
  int searchBlockCurrentPage = 1;

  initBlockList([memberIdx, int? initPage]) async {
    blockCurrentPage = 1;

    final page = initPage ?? state.page;
    final lists = await BlockRepository().getBlockList(
      memberIdx: memberIdx,
      page: page,
    );

    blockMaxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        totalCount: lists.data.params!.pagination!.totalRecordCount!);

    if (lists == null) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }

    state = state.copyWith(page: page, isLoading: false, list: lists.data.list);
  }

  loadMoreBlockList(memberIdx) async {
    if (isBlockSearching) {
      if (searchBlockCurrentPage >= blockMaxPages) {
        state = state.copyWith(isLoadMoreDone: true);
        return;
      }

      state = state.copyWith(
          isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

      final lists = await BlockRepository().getBlockSearchList(
        memberIdx: memberIdx,
        page: searchBlockCurrentPage + 1,
        searchWord: blockSearchWord,
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
        searchBlockCurrentPage++;
      } else {
        state = state.copyWith(isLoading: false);
      }
    } else {
      if (blockCurrentPage >= blockMaxPages) {
        state = state.copyWith(isLoadMoreDone: true);
        return;
      }

      state = state.copyWith(
          isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

      final lists = await BlockRepository().getBlockList(
        memberIdx: memberIdx,
        page: state.page + 1,
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
        blockCurrentPage++;
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> refreshBlockList(memberIdx) async {
    initBlockList(memberIdx, 1);
    blockCurrentPage = 1;
  }

  final blockSearchQuery = PublishSubject<String>();

  Future<void> searchBlockList(String searchWord) async {
    blockSearchWord = searchWord;
    isBlockSearching = true;
    searchBlockCurrentPage = 1;

    final lists = await BlockRepository().getBlockSearchList(
      memberIdx: userMemberIdx,
      page: 1,
      searchWord: searchWord,
    );

    if (lists == null) {
      state = state.copyWith(page: 1, isLoading: false, list: []);
      return;
    }

    state = state.copyWith(page: 1, isLoading: false, list: lists.data.list);
  }

  Future<ResponseModel> deleteBlock({
    required memberIdx,
    required blockIdx,
  }) async {
    final result = await BlockRepository().deleteBlock(
      memberIdx: memberIdx,
      blockIdx: blockIdx,
    );

    await refreshBlockList(memberIdx);

    return result;
  }

  @override
  void dispose() {
    blockSearchQuery.close();
    super.dispose();
  }
}
