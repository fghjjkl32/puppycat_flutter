import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
import 'package:rxdart/rxdart.dart';

final blockStateProvider = StateNotifierProvider<BlockStateNotifier, SearchDataListModel>((ref) {
  return BlockStateNotifier(ref);
});

class BlockStateNotifier extends StateNotifier<SearchDataListModel> {
  final Ref ref;

  BlockStateNotifier(this.ref) : super(const SearchDataListModel()) {
    blockSearchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchBlockList(query);
    });
  }

  int blockMaxPages = 1;
  int blockCurrentPage = 1;

  bool isBlockSearching = false;
  String blockSearchWord = '';
  int searchBlockMaxPages = 1;
  int searchBlockCurrentPage = 1;

  initBlockList([
    int? initPage,
  ]) async {
    blockCurrentPage = 1;

    final page = initPage ?? state.page;

    try {
      final lists = await BlockRepository(dio: ref.read(dioProvider)).getBlockList(
        page: page,
      );

      blockMaxPages = lists.data.params!.pagination?.endPage ?? 0;

      state = state.copyWith(totalCount: lists.data.params!.pagination?.totalRecordCount! ?? 0);

      if (lists == null) {
        state = state.copyWith(page: page, isLoading: false);
        return;
      }

      state = state.copyWith(page: page, isLoading: false, list: lists.data.list);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('block initBlockList error $e');
    }
  }

  loadMoreBlockList() async {
    try {
      if (isBlockSearching) {
        if (searchBlockCurrentPage >= blockMaxPages) {
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

        final lists = await BlockRepository(dio: ref.read(dioProvider)).getBlockSearchList(
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

        StringBuffer bf = StringBuffer();

        bf.write('try to request loading ${state.isLoading} at ${state.page + 1}');
        if (state.isLoading) {
          bf.write(' fail');
          return;
        }
        bf.write(' success');

        state = state.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

        final lists = await BlockRepository(dio: ref.read(dioProvider)).getBlockList(
          page: state.page + 1,
        );

        if (lists == null) {
          state = state.copyWith(isLoadMoreError: true, isLoading: false);
          return;
        }

        if (lists.data.list.isNotEmpty) {
          state = state.copyWith(page: state.page + 1, isLoading: false, list: [...state.list, ...lists.data.list]);
          blockCurrentPage++;
        } else {
          state = state.copyWith(isLoading: false);
        }
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshBlockList() async {
    initBlockList(1);
    blockCurrentPage = 1;
  }

  final blockSearchQuery = PublishSubject<String>();

  Future<void> searchBlockList(String searchWord) async {
    blockSearchWord = searchWord;
    isBlockSearching = true;
    searchBlockCurrentPage = 1;

    try {
      final lists = await BlockRepository(dio: ref.read(dioProvider)).getBlockSearchList(
        page: 1,
        searchWord: searchWord,
      );

      searchBlockMaxPages = lists.data.params!.pagination?.endPage ?? 0;

      if (lists == null) {
        state = state.copyWith(page: 1, isLoading: false, list: []);
        return;
      }

      state = state.copyWith(page: 1, isLoading: false, list: lists.data.list);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('searchBlockList error $e');
    }
  }

  Future<ResponseModel> deleteBlock({
    required String blockUuid,
  }) async {
    try {
      final result = await BlockRepository(dio: ref.read(dioProvider)).deleteBlock(
        blockUuid: blockUuid,
      );

      await refreshBlockList();

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('searchBlockList error $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    blockSearchQuery.close();
    super.dispose();
  }
}
