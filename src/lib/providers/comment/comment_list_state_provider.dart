import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/comment/comment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

part 'comment_list_state_provider.g.dart';

final commentListRefreshFocusProvider = StateProvider<int>((ref) => 0);

@Riverpod(keepAlive: true)
class CommentListState extends _$CommentListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  int _contentsIdx = -1;
  int _commentIdx = -1;
  CommentDataListModel? _childFocusListModel;
  bool _isChildMore = false;

  ListAPIStatus get listStatus => _apiStatus;

  @override
  PagingController<int, CommentData> build() {
    PagingController<int, CommentData> pagingController = PagingController(firstPageKey: 1, invisibleItemsThreshold: 5);
    // pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> fetchPage(int pageKey, [CommentDataListModel? childFocusModel]) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var loginMemberIdx = ref
          .read(userInfoProvider)
          .userModel
          ?.idx;

      final searchResult = await CommentRepository(dio: ref.read(dioProvider)).getComment(
        contentIdx: _contentsIdx,
        page: pageKey,
        memberIdx: loginMemberIdx,
      );

      List<CommentData> commentList = _serializationComment(searchResult.data.list);

      try {
        _lastPage = searchResult.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      print('pageKey $pageKey');
      final nextPageKey = commentList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(commentList);
      } else {
        state.appendPage(commentList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
      state.notifyListeners();
    } on APIException catch(apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void fetchPreviousPage() async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var loginMemberIdx = ref.read(userInfoProvider).userModel?.idx;

      var currentPageKey = state.nextPageKey!.toInt() - 1;
      var previousPageKey = 0;
      if (currentPageKey != null && currentPageKey > 1) {
        previousPageKey = currentPageKey - 1;
      } else {
        return;
      }

      print('previousPageKey $previousPageKey / $currentPageKey');
      final searchResult = await CommentRepository(dio: ref.read(dioProvider)).getComment(
        contentIdx: _contentsIdx,
        page: previousPageKey,
        memberIdx: loginMemberIdx,
      );

      // var searchList = searchResult.data.list;
      List<CommentData> commentList = _serializationComment(searchResult.data.list);

      try {
        _lastPage = searchResult.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      state.itemList = commentList + state.itemList!;
      state.nextPageKey = currentPageKey;
      state.notifyListeners();

      _apiStatus = ListAPIStatus.loaded;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  List<CommentData> _serializationComment(List<CommentData> originalList) {
    List<CommentData> commentList = [];
    for (var element in originalList) {
      commentList.add(element);
      if (element.childCommentData != null) {
        if (element.childCommentData!.list.isNotEmpty) {
          int pageNumber = element.childCommentData!.params.page!;
          int totalPageCount = element.childCommentData!.params.pagination!.totalPageCount!;

          ///NOTE
          ///아래 mapping은 나중에  API  수정되면 다시 원복
          ///for문은 mapping 원복 때 제거
          List<CommentData> childList = element.childCommentData!.list.map((child) {
            return child.copyWith(isReply: true);
          }).toList();

          childList.last = childList.last.copyWith(
            isLastDisPlayChild: pageNumber != totalPageCount,
            pageNumber: pageNumber,
          );

          commentList.addAll(childList);
        }
      }
    }

    // try {
    //   if (_childFocusListModel != null && !_isChildMore) {
    //     CommentData commentData = _childFocusListModel!.list.first;
    //     int pageNumber = _childFocusListModel!.params!.page!;
    //     int totalPageCount = _childFocusListModel!.params!.pagination!.totalPageCount!;
    //
    //     int parentIdx = commentData.parentIdx;
    //     commentList.removeWhere((element) => element.parentIdx == parentIdx);
    //     int insertIdx = commentList.indexWhere((element) => element.idx == parentIdx);
    //     if (insertIdx < 0) {
    //       return commentList;
    //     }
    //
    //     print('parentIdx $parentIdx / insertIdx $insertIdx');
    //     commentData = commentData.copyWith(
    //       isLastDisPlayChild: pageNumber != totalPageCount,
    //       pageNumber: pageNumber + 1,
    //       isReply: true,
    //       isDisplayPreviousMore: pageNumber > 1,
    //     );
    //     commentList.insert(insertIdx + 1, commentData);
    //     // _childFocusListModel = null;
    //   }
    // } catch (e) {
    //   return commentList;
    // }

    return commentList;
  }

  void getComments(int contentsIdx) {
    if (contentsIdx < 0) {
      return;
    }

    _contentsIdx = contentsIdx;

    if (!state.hasListeners) {
      state.addPageRequestListener(fetchPage);
    }

    state.refresh();
  }

  void getFocusingComments(int contentsIdx, int commentIdx) async {
    if (contentsIdx < 0) {
      return;
    }
    if (commentIdx < 0) {
      return;
    }

    print('contentsIdx $contentsIdx / commentIdx $commentIdx');
    _contentsIdx = contentsIdx;
    _commentIdx = commentIdx;

    //int memberIdx, int contentsIdx, int commentIdx, int page,
    try {
      // if (_apiStatus == ListAPIStatus.loading) {
      //   return;
      // }

      // _apiStatus = ListAPIStatus.loading;
      _isChildMore = false;
      var loginMemberIdx = ref.read(userInfoProvider).userModel?.idx;

      CommentResponseModel searchResult = await CommentRepository(dio: ref.read(dioProvider)).getFocusComments(
        loginMemberIdx!,
        contentsIdx,
        commentIdx,
      );

      state.removePageRequestListener(fetchPage);

      int? childPage;
      int parentIdx = 0;
      if (searchResult.data.list != null) {
        if (searchResult.data.list.first.parentIdx > 0) {
          parentIdx = searchResult.data.list.first.parentIdx;
          _childFocusListModel = searchResult.data;
          childPage = searchResult.data.params?.page;

          searchResult = await CommentRepository(dio: ref.read(dioProvider)).getFocusComments(
            loginMemberIdx,
            contentsIdx,
            parentIdx,
          );
        }
      }

      int currentPage = searchResult.data.params!.page!;
      if (currentPage - 1 <= 0) {
        currentPage = 1;
      }

      state.nextPageKey = currentPage;
      print('state.nextPageKey ${state.nextPageKey}');
      // _fetchPage(currentPage); //TEST

      final parentPageResult = await CommentRepository(dio: ref.read(dioProvider)).getComment(
        contentIdx: _contentsIdx,
        page: currentPage,
        memberIdx: loginMemberIdx,
      );

      List<CommentData> commentList = _serializationComment(parentPageResult.data.list);

      if (childPage != null) {
        final childPageResult = await CommentRepository(dio: ref.read(dioProvider)).getReplyComment(
          contentIdx: contentsIdx,
          commentIdx: parentIdx,
          memberIdx: loginMemberIdx,
          page: childPage,
        );

        var searchList = childPageResult.data.list;

        commentList.removeWhere((element) => element.parentIdx == parentIdx);
        int insertIdx = commentList.indexWhere((element) => element.idx == parentIdx);

        if (insertIdx < 0) {
          print('here?? $commentIdx / $commentList');
          return;
        }

        int pageNumber = childPageResult.data.params!.page!;
        int totalPageCount = childPageResult.data.params!.pagination!.totalPageCount!;
        int totalRecordCount = childPageResult.data.params!.pagination!.totalRecordCount!;

        List<CommentData> childList = searchList.map((e) => e.copyWith(isReply: true)).toList();
        childList.first = childList.first.copyWith(isDisplayPreviousMore: pageNumber > 1, pageNumber: pageNumber - 1);
        childList.last = childList.last.copyWith(isLastDisPlayChild: pageNumber != totalPageCount, pageNumber: pageNumber + 1);

        commentList.insertAll(insertIdx + 1, childList);
        print('totalRecordCount - currentList.length ${totalRecordCount - (pageNumber * 10)} / totalRecordCount $totalRecordCount');

        print('searchList.last ${searchList.last}');
      }
      state.appendPage(commentList.toSet().toList(), currentPage + 1);
      state.notifyListeners();

      state.addPageRequestListener(fetchPage);
    } on APIException catch(apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('eeeeeeeeee $e');
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void getChildComments(int contentsIdx, int commentIdx, int lastChildCommentIdx, int page, bool isNext) async {
    if (contentsIdx < 0) {
      return;
    }
    if (commentIdx < 0) {
      return;
    }
    if (page <= 0) {
      return;
    }

    try {
      var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;

      final searchResult = await CommentRepository(dio: ref.read(dioProvider)).getReplyComment(
        contentIdx: contentsIdx,
        commentIdx: commentIdx,
        memberIdx: loginMemberIdx,
        page: page,
      );

      var searchList = searchResult.data.list;

      List<CommentData> currentList = state.itemList ?? [];
      int insertIdx = currentList.indexWhere((element) => element.idx == lastChildCommentIdx);

      if (insertIdx < 0) {
        print('here? $lastChildCommentIdx');
        return;
      }

      int pageNumber = searchResult.data.params!.page!;
      int totalPageCount = searchResult.data.params!.pagination!.totalPageCount!;
      int totalRecordCount = searchResult.data.params!.pagination!.totalRecordCount!;

      List<CommentData> childList = searchList.map((e) => e.copyWith(isReply: true)).toList();

      if (isNext) {
        currentList[insertIdx] = currentList[insertIdx].copyWith(isLastDisPlayChild: false);
        childList.last = childList.last.copyWith(isLastDisPlayChild: pageNumber != totalPageCount, pageNumber: pageNumber + 1);
      } else {
        int parentIdx = currentList.indexWhere((element) => element.idx == commentIdx);
        currentList[parentIdx + 1] = currentList[parentIdx + 1].copyWith(isDisplayPreviousMore: false);
        childList.first = childList.first.copyWith(isDisplayPreviousMore: pageNumber > 1);
      }

      currentList.insertAll(isNext ? insertIdx + 1 : insertIdx, childList);

      print('searchList.last ${searchList.last}');
      state.itemList = currentList.toSet().toList();
      _isChildMore = true;
      state.notifyListeners();
    } on APIException catch(apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('error $e');
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }
}
