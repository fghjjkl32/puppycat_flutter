import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_post_state.dart';
import 'package:pet_mobile_social_flutter/models/my_page/select_post.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/keep_contents/keep_contents_repository.dart';

final myPostStateProvider = StateNotifierProvider<MyPostStateNotifier, MyPostState>((ref) {
  return MyPostStateNotifier(ref);
});

class MyPostStateNotifier extends StateNotifier<MyPostState> {
  MyPostStateNotifier(this.ref)
      : super(MyPostState(
          myPostState: SelectPost(),
          myKeepState: SelectPost(),
        ));

  int myPostMaxPages = 1;
  int myCurrentPage = 1;
  int myKeepMaxPages = 1;
  int myKeepCurrentPage = 1;

  final Ref ref;

  initMyPosts([int? initPage]) async {
    myCurrentPage = 1;

    try {
      final page = initPage ?? state.myPostState.page;

      final lists = await FeedRepository(dio: ref.read(dioProvider)).getMyContentList(page: page);

      myPostMaxPages = lists.data.params!.pagination?.endPage ?? 0;

      state = state.copyWith(myPostState: state.myPostState.copyWith(totalCount: lists.data.params!.pagination?.totalRecordCount! ?? 0));

      if (lists == null) {
        state = state.copyWith(myPostState: state.myPostState.copyWith(page: page, isLoading: false));
        return;
      }

      List<int> selectOrder = List.filled(lists.data.list.length, -1);

      state = state.copyWith(
        myPostState: state.myPostState.copyWith(page: page, isLoading: false, list: lists.data.list, selectOrder: selectOrder),
      ); // Modify this line
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('initMyPosts error $e');
    }
  }

  bool hasMyPostSelectedImage() {
    return state.myPostState.selectOrder.any((order) => order != -1);
  }

  void resetMyPostSelection() {
    List<int> newOrderList = List.filled(state.myPostState.list.length, -1);
    state = state.copyWith(myPostState: state.myPostState.copyWith(selectOrder: newOrderList, currentOrder: 1));
  }

  void updateMyPostSelectOrder(int index, int order) {
    final newOrderList = List<int>.from(state.myPostState.selectOrder);
    newOrderList[index] = order;
    state = state.copyWith(myPostState: state.myPostState.copyWith(selectOrder: newOrderList));
  }

  void updateMyPostCurrentOrder(int order) {
    state = state.copyWith(myPostState: state.myPostState.copyWith(currentOrder: order));
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

  loadMoreMyPost() async {
    if (myCurrentPage >= myPostMaxPages) {
      state = state.copyWith(myPostState: state.myPostState.copyWith(isLoadMoreDone: true));
      return;
    }

    StringBuffer bf = StringBuffer();

    try {
      bf.write('try to request loading ${state.myPostState.isLoading} at ${state.myPostState.page + 1}');
      if (state.myPostState.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(myPostState: state.myPostState.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

      final lists = await FeedRepository(dio: ref.read(dioProvider)).getMyContentList(page: state.myPostState.page + 1);

      if (lists == null) {
        state = state.copyWith(myPostState: state.myPostState.copyWith(isLoadMoreError: true, isLoading: false));
        return;
      }

      if (lists.data.list.isNotEmpty) {
        List<int> newSelectOrder = List.filled(lists.data.list.length, -1);

        state = state.copyWith(
            myPostState: state.myPostState.copyWith(
                page: state.myPostState.page + 1, isLoading: false, list: [...state.myPostState.list, ...lists.data.list], selectOrder: [...state.myPostState.selectOrder, ...newSelectOrder]));
        myCurrentPage++;
      } else {
        state = state.copyWith(myPostState: state.myPostState.copyWith(isLoading: false));
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('loadMoreMyPost error $e');
    }
  }

  Future<void> refreshMyPost() async {
    initMyPosts(1);
    myCurrentPage = 1;
  }

  List<int> getSelectedMyPostImageIdx() {
    return List<int>.generate(state.myPostState.list.length, (i) => i).where((index) => state.myPostState.selectOrder[index] != -1).map((index) => state.myPostState.list[index].idx).toList();
  }

  Future<ResponseModel> postKeepContents({required List<int> idxList}) async {
    try {
      final result = await KeepContentsRepository(dio: ref.read(dioProvider)).postKeepContents(idxList: idxList);

      await refreshMyKeeps();
      await refreshMyPost();

      resetMyPostSelection();
      resetMyKeepSelection();

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('postKeepContents error $e');
      rethrow;
    }
  }

  initMyKeeps([int? initPage]) async {
    myKeepCurrentPage = 1;

    try {
      final page = initPage ?? state.myKeepState.page;
      final lists = await KeepContentsRepository(dio: ref.read(dioProvider)).getKeepContents(page: page);

      myKeepMaxPages = lists.data.params!.pagination?.endPage ?? 0;

      state = state.copyWith(myKeepState: state.myKeepState.copyWith(totalCount: lists.data.params!.pagination?.totalRecordCount! ?? 0));

      if (lists == null) {
        state = state.copyWith(myKeepState: state.myKeepState.copyWith(page: page, isLoading: false));
        return;
      }

      List<ContentImageData> images = lists.data.list;
      List<int> selectOrder = List.filled(images.length, -1);

      state = state.copyWith(myKeepState: state.myKeepState.copyWith(page: page, isLoading: false, list: images, selectOrder: selectOrder));
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('initMyKeeps error $e');
    }
  }

  bool hasMyKeepSelectedImage() {
    print(state.myKeepState.selectOrder);
    return state.myKeepState.selectOrder.any((order) => order != -1);
  }

  void resetMyKeepSelection() {
    List<int> newOrderList = List.filled(state.myKeepState.list.length, -1);
    state = state.copyWith(myKeepState: state.myKeepState.copyWith(selectOrder: newOrderList, currentOrder: 1));
  }

  void updateMyKeepSelectOrder(int index, int order) {
    final newOrderList = List<int>.from(state.myKeepState.selectOrder);
    newOrderList[index] = order;
    state = state.copyWith(myKeepState: state.myKeepState.copyWith(selectOrder: newOrderList));
  }

  void updateMyKeepCurrentOrder(int order) {
    state = state.copyWith(myKeepState: state.myKeepState.copyWith(currentOrder: order));
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

  loadMoreMyKeeps() async {
    if (myKeepCurrentPage >= myKeepMaxPages) {
      state = state.copyWith(myKeepState: state.myKeepState.copyWith(isLoadMoreDone: true));
      return;
    }

    try {
      StringBuffer bf = StringBuffer();

      bf.write('try to request loading ${state.myKeepState.isLoading} at ${state.myKeepState.page + 1}');
      if (state.myKeepState.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(myKeepState: state.myKeepState.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

      final lists = await KeepContentsRepository(dio: ref.read(dioProvider)).getKeepContents(page: state.myKeepState.page + 1);

      if (lists == null) {
        state = state.copyWith(myKeepState: state.myKeepState.copyWith(isLoadMoreError: true, isLoading: false));
        return;
      }

      if (lists.data.list.isNotEmpty) {
        List<int> newSelectOrder = List.filled(lists.data.list.length, -1);

        state = state.copyWith(
            myKeepState: state.myKeepState.copyWith(
                page: state.myKeepState.page + 1, isLoading: false, list: [...state.myKeepState.list, ...lists.data.list], selectOrder: [...state.myKeepState.selectOrder, ...newSelectOrder]));
        myKeepCurrentPage++;
      } else {
        state = state.copyWith(myKeepState: state.myKeepState.copyWith(isLoading: false));
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('loadMoreMyKeeps error $e');
    }
  }

  Future<void> refreshMyKeeps() async {
    initMyKeeps(1);
    myKeepCurrentPage = 1;
  }

  Future<ResponseModel> deleteKeepContents({required idx}) async {
    try {
      final result = await KeepContentsRepository(dio: ref.read(dioProvider)).deleteKeepContents(idx: idx);

      await refreshMyKeeps();
      await refreshMyPost();

      resetMyPostSelection();
      resetMyKeepSelection();

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('deleteKeepContents error $e');
      rethrow;
    }
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

  Future<ResponseModel> deleteContents({required idx}) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteContents(idx: idx);

      await refreshMyKeeps();
      await refreshMyPost();

      resetMyPostSelection();
      resetMyKeepSelection();

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('my post deleteContents error $e');
      rethrow;
    }
  }
}
