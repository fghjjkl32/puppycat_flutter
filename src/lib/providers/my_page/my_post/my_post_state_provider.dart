import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_post_state.dart';
import 'package:pet_mobile_social_flutter/models/my_page/select_post.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/repositories/main/contents/contents_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/keep_contents/keep_contents_repository.dart';

final myPostStateProvider =
    StateNotifierProvider<MyPostStateNotifier, MyPostState>((ref) {
  return MyPostStateNotifier();
});

class MyPostStateNotifier extends StateNotifier<MyPostState> {
  MyPostStateNotifier()
      : super(MyPostState(
          myPostState: SelectPost(),
          myKeepState: SelectPost(),
        ));

  int myPostMaxPages = 1;
  int myCurrentPage = 1;
  int myKeepMaxPages = 1;
  int myKeepCurrentPage = 1;

  initMyPosts([memberIdx, int? initPage]) async {
    myCurrentPage = 1;

    final page = initPage ?? state.myPostState.page;

    final lists = await FeedRepository()
        .getMyContentList(loginMemberIdx: memberIdx, page: page);

    myPostMaxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        myPostState: state.myPostState.copyWith(
            totalCount: lists.data.params!.pagination!.totalRecordCount!));

    if (lists == null) {
      state = state.copyWith(
          myPostState:
              state.myPostState.copyWith(page: page, isLoading: false));
      return;
    }

    List<int> selectOrder = List.filled(lists.data.list.length, -1);

    state = state.copyWith(
      myPostState: state.myPostState.copyWith(
          page: page,
          isLoading: false,
          list: lists.data.list,
          selectOrder: selectOrder),
    ); // Modify this line
  }

  bool hasMyPostSelectedImage() {
    return state.myPostState.selectOrder.any((order) => order != -1);
  }

  void resetMyPostSelection() {
    List<int> newOrderList = List.filled(state.myPostState.list.length, -1);
    state = state.copyWith(
        myPostState: state.myPostState
            .copyWith(selectOrder: newOrderList, currentOrder: 1));
  }

  void updateMyPostSelectOrder(int index, int order) {
    final newOrderList = List<int>.from(state.myPostState.selectOrder);
    newOrderList[index] = order;
    state = state.copyWith(
        myPostState: state.myPostState.copyWith(selectOrder: newOrderList));
  }

  void updateMyPostCurrentOrder(int order) {
    state = state.copyWith(
        myPostState: state.myPostState.copyWith(currentOrder: order));
  }

  void updateMyPostNumber(int index) {
    if (state.myPostState.selectOrder[index] == -1) {
      updateMyPostSelectOrder(index, state.myPostState.currentOrder);
      updateMyPostCurrentOrder(state.myPostState.currentOrder + 1);
    } else {
      int removedOrder = state.myPostState.selectOrder[index];
      updateMyPostSelectOrder(index, -1);
      updateMyPostCurrentOrder(state.myPostState.currentOrder - 1);
      for (int i = 0; i < state.myPostState.selectOrder.length; i++) {
        if (state.myPostState.selectOrder[i] > removedOrder) {
          updateMyPostSelectOrder(i, state.myPostState.selectOrder[i] - 1);
        }
      }
    }
  }

  loadMoreMyPost(memberIdx) async {
    if (myCurrentPage >= myPostMaxPages) {
      state = state.copyWith(
          myPostState: state.myPostState.copyWith(isLoadMoreDone: true));
      return;
    }

    StringBuffer bf = StringBuffer();

    bf.write(
        'try to request loading ${state.myPostState.isLoading} at ${state.myPostState.page + 1}');
    if (state.myPostState.isLoading) {
      bf.write(' fail');
      return;
    }
    bf.write(' success');

    state = state.copyWith(
        myPostState: state.myPostState.copyWith(
            isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

    final lists = await FeedRepository().getMyContentList(
        loginMemberIdx: memberIdx, page: state.myPostState.page + 1);

    if (lists == null) {
      state = state.copyWith(
          myPostState: state.myPostState
              .copyWith(isLoadMoreError: true, isLoading: false));
      return;
    }

    if (lists.data.list.isNotEmpty) {
      List<int> newSelectOrder = List.filled(lists.data.list.length, -1);

      state = state.copyWith(
          myPostState: state.myPostState.copyWith(
              page: state.myPostState.page + 1,
              isLoading: false,
              list: [
            ...state.myPostState.list,
            ...lists.data.list
          ],
              selectOrder: [
            ...state.myPostState.selectOrder,
            ...newSelectOrder
          ]));
      myCurrentPage++;
    } else {
      state = state.copyWith(
          myPostState: state.myPostState.copyWith(isLoading: false));
    }
  }

  Future<void> refreshMyPost(memberIdx) async {
    initMyPosts(memberIdx, 1);
    myCurrentPage = 1;
  }

  List<int> getSelectedMyPostImageIdx() {
    return List<int>.generate(state.myPostState.list.length, (i) => i)
        .where((index) => state.myPostState.selectOrder[index] != -1)
        .map((index) => state.myPostState.list[index].idx)
        .toList();
  }

  Future<ResponseModel> postKeepContents(
      {required memberIdx, required idxList}) async {
    final result = await KeepContentsRepository()
        .postKeepContents(memberIdx: memberIdx, idxList: idxList);

    await refreshMyKeeps(memberIdx);
    await refreshMyPost(memberIdx);

    resetMyPostSelection();
    resetMyKeepSelection();

    return result;
  }

  initMyKeeps([memberIdx, int? initPage]) async {
    myKeepCurrentPage = 1;

    final page = initPage ?? state.myKeepState.page;
    final lists = await KeepContentsRepository()
        .getKeepContents(memberIdx: memberIdx, page: page);

    myKeepMaxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
        myKeepState: state.myKeepState.copyWith(
            totalCount: lists.data.params!.pagination!.totalRecordCount!));

    if (lists == null) {
      state = state.copyWith(
          myKeepState:
              state.myKeepState.copyWith(page: page, isLoading: false));
      return;
    }

    List<ContentImageData> images = lists.data.list;
    List<int> selectOrder = List.filled(images.length, -1);

    state = state.copyWith(
        myKeepState: state.myKeepState.copyWith(
            page: page,
            isLoading: false,
            list: images,
            selectOrder: selectOrder));
  }

  bool hasMyKeepSelectedImage() {
    return state.myKeepState.selectOrder.any((order) => order != -1);
  }

  void resetMyKeepSelection() {
    List<int> newOrderList = List.filled(state.myKeepState.list.length, -1);
    state = state.copyWith(
        myKeepState: state.myKeepState
            .copyWith(selectOrder: newOrderList, currentOrder: 1));
  }

  void updateMyKeepSelectOrder(int index, int order) {
    final newOrderList = List<int>.from(state.myKeepState.selectOrder);
    newOrderList[index] = order;
    state = state.copyWith(
        myKeepState: state.myKeepState.copyWith(selectOrder: newOrderList));
  }

  void updateMyKeepCurrentOrder(int order) {
    state = state.copyWith(
        myKeepState: state.myKeepState.copyWith(currentOrder: order));
  }

  void updateMyKeepNumber(int index) {
    if (state.myKeepState.selectOrder[index] == -1) {
      updateMyKeepSelectOrder(index, state.myKeepState.currentOrder);
      updateMyKeepCurrentOrder(state.myKeepState.currentOrder + 1);
    } else {
      int removedOrder = state.myKeepState.selectOrder[index];
      updateMyKeepSelectOrder(index, -1);
      updateMyKeepCurrentOrder(state.myKeepState.currentOrder - 1);
      for (int i = 0; i < state.myKeepState.selectOrder.length; i++) {
        if (state.myKeepState.selectOrder[i] > removedOrder) {
          updateMyKeepSelectOrder(i, state.myKeepState.selectOrder[i] - 1);
        }
      }
    }
  }

  loadMoreMyKeeps(memberIdx) async {
    if (myKeepCurrentPage >= myKeepMaxPages) {
      state = state.copyWith(
          myKeepState: state.myKeepState.copyWith(isLoadMoreDone: true));
      return;
    }

    StringBuffer bf = StringBuffer();

    bf.write(
        'try to request loading ${state.myKeepState.isLoading} at ${state.myKeepState.page + 1}');
    if (state.myKeepState.isLoading) {
      bf.write(' fail');
      return;
    }
    bf.write(' success');

    state = state.copyWith(
        myKeepState: state.myKeepState.copyWith(
            isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

    final lists = await KeepContentsRepository().getKeepContents(
        memberIdx: memberIdx, page: state.myKeepState.page + 1);

    if (lists == null) {
      state = state.copyWith(
          myKeepState: state.myKeepState
              .copyWith(isLoadMoreError: true, isLoading: false));
      return;
    }

    if (lists.data.list.isNotEmpty) {
      List<int> newSelectOrder = List.filled(lists.data.list.length, -1);

      state = state.copyWith(
          myKeepState: state.myKeepState.copyWith(
              page: state.myKeepState.page + 1,
              isLoading: false,
              list: [
            ...state.myKeepState.list,
            ...lists.data.list
          ],
              selectOrder: [
            ...state.myKeepState.selectOrder,
            ...newSelectOrder
          ]));
      myKeepCurrentPage++;
    } else {
      state = state.copyWith(
          myKeepState: state.myKeepState.copyWith(isLoading: false));
    }
  }

  Future<void> refreshMyKeeps(memberIdx) async {
    initMyKeeps(memberIdx, 1);
    myKeepCurrentPage = 1;
  }

  Future<ResponseModel> deleteKeepContents(
      {required memberIdx, required idx}) async {
    final result = await KeepContentsRepository()
        .deleteKeepContents(memberIdx: memberIdx, idx: idx);

    await refreshMyKeeps(memberIdx);
    await refreshMyPost(memberIdx);

    resetMyPostSelection();
    resetMyKeepSelection();

    return result;
  }

  String getSelectedImageIndices({required bool isKeepSelect}) {
    List<String> indices = [];
    if (isKeepSelect) {
      for (int i = 0; i < state.myKeepState.selectOrder.length; i++) {
        if (state.myKeepState.selectOrder[i] != -1) {
          indices.add('idx=${state.myKeepState.list[i].idx}');
        }
      }
    } else {
      for (int i = 0; i < state.myPostState.selectOrder.length; i++) {
        if (state.myPostState.selectOrder[i] != -1) {
          indices.add('idx=${state.myPostState.list[i].idx}');
        }
      }
    }

    return indices.join('&');
  }

  Future<ResponseModel> deleteContents(
      {required memberIdx, required idx}) async {
    final result = await ContentsRepository()
        .deleteContents(memberIdx: memberIdx, idx: idx);

    await refreshMyKeeps(memberIdx);
    await refreshMyPost(memberIdx);

    resetMyPostSelection();
    resetMyKeepSelection();

    return result;
  }
}
