import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/comment/comment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

part 'comment_list_state_provider.g.dart';


@Riverpod(keepAlive: true)
class CommentListState extends _$CommentListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  int _contentsIdx = -1;
  int _commentIdx = -1;

  ListAPIStatus get listStatus => _apiStatus;

  @override
  PagingController<int, CommentData> build() {
    PagingController<int, CommentData> pagingController = PagingController(firstPageKey: 1);
    // pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  // PagingController<int, CommentData> _initController(int firstPageKey) {
  //   PagingController<int, CommentData> pagingController = PagingController(firstPageKey: firstPageKey);
  //   return pagingController;
  // }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;

      final searchResult = await CommentRepository().getComment(
        contentIdx: _contentsIdx,
        page: pageKey,
        memberIdx: loginMemberIdx,
      );

      var searchList = searchResult.data.list;

      try {
        _lastPage = searchResult.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      print('pageKey $pageKey');
      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
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

      var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;

      var currentPageKey = state.nextPageKey!.toInt() - 1;
      var previousPageKey = 0;
      if(currentPageKey != null && currentPageKey > 1) {
        previousPageKey = currentPageKey - 1;
      } else {
        return;
      }

      print('previousPageKey $previousPageKey / $currentPageKey');
      final searchResult = await CommentRepository().getComment(
        contentIdx: _contentsIdx,
        page: previousPageKey,
        memberIdx: loginMemberIdx,
      );

      var searchList = searchResult.data.list;

      try {
        _lastPage = searchResult.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      state.itemList = searchList + state.itemList!;
      state.nextPageKey = currentPageKey;
      state.notifyListeners();

      _apiStatus = ListAPIStatus.loaded;
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void getComments(int contentsIdx) {
    if (contentsIdx < 0) {
      return;
    }

    _contentsIdx = contentsIdx;

    if(!state.hasListeners) {
      state.addPageRequestListener(_fetchPage);
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

    _contentsIdx = contentsIdx;
    _commentIdx = commentIdx;

    //int memberIdx, int contentsIdx, int commentIdx, int page,
    try {
      // if (_apiStatus == ListAPIStatus.loading) {
      //   return;
      // }

      // _apiStatus = ListAPIStatus.loading;

      var loginMemberIdx = ref
          .read(userInfoProvider)
          .userModel!
          .idx;

      final searchResult = await CommentRepository().getFocusComments(
        loginMemberIdx,
        contentsIdx,
        commentIdx,
      );

      state.removePageRequestListener(_fetchPage);
      print('searchResult $searchResult');
      int currentPage = searchResult.data.params!.page!;
      // _lastPage = searchResult.data.params!.pagination!.totalPageCount!;
      if(currentPage - 1 <= 0) {
        currentPage = 1;
      } else {
        currentPage = currentPage - 1;
      }
      state.nextPageKey = currentPage;
      print('state.nextPageKey ${state.nextPageKey}');
      state.itemList = []; //TODO 나중에 함수로 빼두기
      _fetchPage(3); //TEST
      // _fetchPage(currentPage); //NOTE 다시 바꿔야함
      state.addPageRequestListener(_fetchPage);
      // state.refresh();
      // state
      // var searchList = searchResult.data.list;
      // state.appendPage(searchList, currentPage + 1);

      // _apiStatus = ListAPIStatus.loaded;
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }
}
