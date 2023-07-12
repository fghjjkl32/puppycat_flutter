import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_post_state.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/user_contents/user_contents_repository.dart';

class MyPostStateNotifier extends StateNotifier<MyPostState> {
  MyPostStateNotifier() : super(MyPostState());

  int maxPages = 1;
  int currentPage = 1;

  initPosts([memberIdx, int? initPage]) async {
    final page = initPage ?? state.page;
    final lists = await UserContentsRepository()
        .getUserContents(memberIdx: memberIdx, page: page);

    maxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        totalCount: lists.data.params!.pagination!.totalRecordCount!);

    if (lists == null) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }

    // Initialize the selection order to -1 for all images
    List<ContentImageData> images = lists.data.list;
    List<int> selectOrder = List.filled(images.length, -1); // Add this line

    state = state.copyWith(
        page: page,
        isLoading: false,
        list: images,
        selectOrder: selectOrder); // Modify this line
  }

  bool hasSelectedImage() {
    return state.selectOrder.any((order) => order != -1);
  }

  void resetSelection() {
    List<int> newOrderList = List.filled(state.list.length, -1);
    state = state.copyWith(selectOrder: newOrderList, currentOrder: 1);
  }

  void updateSelectOrder(int index, int order) {
    final newOrderList = List<int>.from(state.selectOrder);
    newOrderList[index] = order;
    state = state.copyWith(selectOrder: newOrderList);
  }

  void updateCurrentOrder(int order) {
    state = state.copyWith(currentOrder: order);
  }

  void updateNumber(index) {
    if (state.selectOrder[index] == -1) {
      updateSelectOrder(index, state.currentOrder);
      updateCurrentOrder(state.currentOrder + 1);
    } else {
      int removedOrder = state.selectOrder[index];
      updateSelectOrder(index, -1);
      updateCurrentOrder(state.currentOrder - 1);
      for (int i = 0; i < state.selectOrder.length; i++) {
        if (state.selectOrder[i] > removedOrder) {
          updateSelectOrder(i, state.selectOrder[i] - 1);
        }
      }
    }
  }

  loadMorePost(memberIdx) async {
    if (currentPage >= maxPages) {
      state = state.copyWith(isLoadMoreDone: true);
      return;
    }

    state = state.copyWith(
        isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

    final lists = await UserContentsRepository()
        .getUserContents(memberIdx: memberIdx, page: state.page + 1);

    if (lists == null) {
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
      return;
    }

    if (lists.data.list.isNotEmpty) {
      // Extend the selection order to include the new images
      List<int> newSelectOrder =
          List.filled(lists.data.list.length, -1); // Add this line

      state = state.copyWith(
          page: state.page + 1,
          isLoading: false,
          list: [
            ...state.list,
            ...lists.data.list
          ], // Add this line
          selectOrder: [
            ...state.selectOrder,
            ...newSelectOrder
          ]); // Modify this line
      currentPage++;
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh(memberIdx) async {
    initPosts(memberIdx, 1);
    currentPage = 1;
  }
}

final myPostStateProvider =
    StateNotifierProvider<MyPostStateNotifier, MyPostState>(
  (ref) => MyPostStateNotifier(),
);
