import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/models/comment/comment_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/comment/comment_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/feed/feed_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_list_state_provider.g.dart';

final commentLikeApiIsLoadingStateProvider = StateProvider<bool>((ref) => false);
final commentListRefreshFocusProvider = StateProvider<int>((ref) => 0);

@Riverpod(keepAlive: true)
class CommentListState extends _$CommentListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  int _contentsIdx = -1;
  int _commentIdx = -1;
  CommentDataListModel? _childFocusListModel;
  bool _isChildMore = false;

  int? tempCommentDataIndex;
  CommentData? tempCommentData;

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

      final searchResult = await CommentRepository(dio: ref.read(dioProvider)).getComment(
        contentIdx: _contentsIdx,
        page: pageKey,
      );

      List<CommentData> commentList = _serializationComment(searchResult.list);

      try {
        _lastPage = searchResult.params!.pagination?.totalPageCount! ?? 0;
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
    } on APIException catch (apiException) {
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
      );

      // var searchList = searchResult.data.list;
      List<CommentData> commentList = _serializationComment(searchResult.list);

      try {
        _lastPage = searchResult.params!.pagination?.totalPageCount! ?? 0;
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
          int totalPageCount = element.childCommentData!.params.pagination?.totalPageCount! ?? 0;

          ///NOTE
          ///아래 mapping은 나중에  API  수정되면 다시 원복
          ///for문은 mapping 원복 때 제거
          List<CommentData> childList = element.childCommentData!.list.map((child) {
            return child.copyWith(isReply: true);
          }).toList();

          print("pageNumber :: ${pageNumber}");
          print("totalPageCount :: ${totalPageCount}");

          childList.last = childList.last.copyWith(
            isLastDisPlayChild: pageNumber != totalPageCount,
            pageNumber: pageNumber,
          );

          commentList.addAll(childList);
        }
      }
    }
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
      //TODO 11/17 리스트 초기화 하기 위해 추가함
      state.itemList = null;
      // if (_apiStatus == ListAPIStatus.loading) {
      //   return;
      // }

      // _apiStatus = ListAPIStatus.loading;
      _isChildMore = false;
      state.removePageRequestListener(fetchPage);

      CommentDataListModel searchResult = await CommentRepository(dio: ref.read(dioProvider)).getFocusComments(
        contentsIdx,
        commentIdx,
      );

      int? childPage;
      int parentIdx = 0;
      if (searchResult.list != null) {
        if (searchResult.list.first.parentIdx > 0) {
          parentIdx = searchResult.list.first.parentIdx;
          _childFocusListModel = searchResult;
          childPage = searchResult.params?.page;

          searchResult = await CommentRepository(dio: ref.read(dioProvider)).getFocusComments(
            contentsIdx,
            parentIdx,
          );
        }
      }

      int currentPage = searchResult.params!.page!;
      if (currentPage - 1 <= 0) {
        currentPage = 1;
      }

      // state.nextPageKey = currentPage;
      // print('state.nextPageKey ${state.nextPageKey}');
      // _fetchPage(currentPage); //TEST

      final parentPageResult = await CommentRepository(dio: ref.read(dioProvider)).getComment(
        contentIdx: _contentsIdx,
        page: currentPage,
      );

      List<CommentData> commentList = _serializationComment(parentPageResult.list);

      if (childPage != null) {
        final childPageResult = await CommentRepository(dio: ref.read(dioProvider)).getReplyComment(
          contentIdx: contentsIdx,
          commentIdx: parentIdx,
          page: childPage,
        );

        var searchList = childPageResult.list;

        commentList.removeWhere((element) => element.parentIdx == parentIdx);
        int insertIdx = commentList.indexWhere((element) => element.idx == parentIdx);

        if (insertIdx < 0) {
          print('here?? $commentIdx / $commentList');
          return;
        }

        int pageNumber = childPageResult.params!.page!;
        int totalPageCount = childPageResult.params!.pagination?.totalPageCount! ?? 0;
        int totalRecordCount = childPageResult.params!.pagination?.totalRecordCount! ?? 0;

        List<CommentData> childList = searchList.map((e) => e.copyWith(isReply: true)).toList();
        childList.first = childList.first.copyWith(isDisplayPreviousMore: pageNumber > 1, pageNumber: pageNumber - 1);
        childList.last = childList.last.copyWith(isLastDisPlayChild: pageNumber != totalPageCount, pageNumber: pageNumber + 1);

        commentList.insertAll(insertIdx + 1, childList);
        print('totalRecordCount - currentList.length ${totalRecordCount - (pageNumber * 10)} / totalRecordCount $totalRecordCount');

        print('searchList.last ${searchList.last}');
      }

      int lastPage = 1;
      try {
        lastPage = parentPageResult.params!.pagination?.totalPageCount! ?? 0;
      } catch (_) {
        lastPage = 1;
      }

      print('11111 pageKey $currentPage');
      final nextPageKey = commentList.isEmpty ? null : currentPage + 1;

      print('lastPage $lastPage / currentPage $currentPage / nextPageKey $nextPageKey');
      if (currentPage == lastPage) {
        state.appendLastPage(commentList.toSet().toList());
      } else {
        state.appendPage(commentList.toSet().toList(), nextPageKey);
        state.nextPageKey = nextPageKey;
        state.addPageRequestListener(fetchPage);
      }

      //
      // //TODO 11/17 리스트 중복 제거 하기 위해 추가
      // var uniqueComments = Map<int, CommentData>();
      // for (var comment in commentList) {
      //   uniqueComments[comment.idx] = comment;
      // }
      // //TODO 11/17 무한으로 리스트 나오는 문제 떄문에 수정함
      // //currentPage + 1 => currentPage 으로 수정
      // //하지만 페이지 불러오고 그다음 로직을 태우도록 비동기를 걸어놔도 addPageRequestListener를 1페이지 부터 렌더링을 하는 이슈가 있음
      // //removePageRequestListener를 해도 여전히 동일
      // state.appendPage(uniqueComments.values.toList(), currentPage);
      state.notifyListeners();
    } on APIException catch (apiException) {
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
      final searchResult = await CommentRepository(dio: ref.read(dioProvider)).getReplyComment(
        contentIdx: contentsIdx,
        commentIdx: commentIdx,
        page: page,
      );

      var searchList = searchResult.list;

      List<CommentData> currentList = state.itemList ?? [];
      int insertIdx = currentList.indexWhere((element) => element.idx == lastChildCommentIdx);

      if (insertIdx < 0) {
        print('here? $lastChildCommentIdx');
        return;
      }

      int pageNumber = searchResult.params!.page!;
      int totalPageCount = searchResult.params!.pagination?.totalPageCount! ?? 0;
      int totalRecordCount = searchResult.params!.pagination?.totalRecordCount! ?? 0;

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

      var uniqueComments = Map<int, CommentData>();
      for (var comment in currentList) {
        uniqueComments[comment.idx] = comment;
      }
      state.itemList = uniqueComments.values.toList();
      _isChildMore = true;
      state.notifyListeners();
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('error $e');
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  ///TODO
  ///함수명이랑 기능이랑 안맞음
  Future<ResponseModel> deleteContents({
    required contentsIdx,
    required commentIdx,
    required parentIdx,
  }) async {
    final result = await CommentRepository(dio: ref.read(dioProvider)).deleteComment(
      contentsIdx: contentsIdx,
      commentIdx: commentIdx,
      parentIdx: parentIdx,
    );

    int targetIdx = -1;

    if (state.itemList != null) {
      targetIdx = state.itemList!.indexWhere((element) => element.idx == commentIdx);

      if (targetIdx != -1) {
        tempCommentData = state.itemList![targetIdx];

        state.itemList!.removeAt(targetIdx);

        state.notifyListeners();
      }
    }

    return result;
  }

  Future<ResponseModel> postContents({
    required contents,
    required contentIdx,
    int? parentIdx,
  }) async {
    try {
      final result = await CommentRepository(dio: ref.read(dioProvider)).postComment(contents: contents, parentIdx: parentIdx, contentIdx: contentIdx);

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> editContents({
    required int commentIdx,
    required String contents,
    required int contentIdx,
  }) async {
    try {
      final result = await CommentRepository(dio: ref.read(dioProvider)).editComment(
        contents: contents,
        contentIdx: contentIdx,
        commentIdx: commentIdx,
      );

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> postCommentLike({
    required commentIdx,
  }) async {
    ref.read(commentLikeApiIsLoadingStateProvider.notifier).state = true;

    final result = await CommentRepository(dio: ref.read(dioProvider)).postCommentLike(commentIdx: commentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      targetIdx = state.itemList!.indexWhere((element) => element.idx == commentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          likeState: 1,
          commentLikeCnt: state.itemList![targetIdx].commentLikeCnt! + 1,
        );
        state.notifyListeners();
      }
    }

    ref.read(commentLikeApiIsLoadingStateProvider.notifier).state = false;

    return result;
  }

  Future<ResponseModel> deleteCommentLike({
    required commentIdx,
  }) async {
    ref.read(commentLikeApiIsLoadingStateProvider.notifier).state = true;

    final result = await CommentRepository(dio: ref.read(dioProvider)).deleteCommentLike(commentIdx: commentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      targetIdx = state.itemList!.indexWhere((element) => element.idx == commentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          likeState: 0,
          commentLikeCnt: state.itemList![targetIdx].commentLikeCnt! - 1,
        );
        state.notifyListeners();
      }
    }

    ref.read(commentLikeApiIsLoadingStateProvider.notifier).state = false;

    return result;
  }

  Future<ResponseModel> postBlock({
    required String blockUuid,
  }) async {
    final result = await BlockRepository(dio: ref.read(dioProvider)).postBlock(
      blockUuid: blockUuid,
    );

    if (state.itemList != null) {
      state.itemList!.removeWhere((element) => element.memberUuid == blockUuid);
      state.notifyListeners();
    }

    return result;
  }

  Future<ResponseModel> postCommentReport({
    required int contentIdx,
    required int reportCode,
    required String? reason,
    required String reportType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).postContentReport(
      reportType: reportType,
      contentIdx: contentIdx,
      reportCode: reportCode,
      reason: reason,
    );

    int targetIdx = -1;

    if (state.itemList != null) {
      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      tempCommentDataIndex = targetIdx;

      if (targetIdx != -1) {
        tempCommentData = state.itemList![targetIdx];

        state.itemList!.removeAt(targetIdx);
        state.notifyListeners();
      }
    }

    return result;
  }

  Future<ResponseModel> deleteCommentReport({
    required String reportType,
    required int contentIdx,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).deleteContentReport(
      reportType: reportType,
      contentsIdx: contentIdx,
    );

    if (state.itemList != null) {
      if (tempCommentDataIndex != null && tempCommentDataIndex != -1) {
        state.itemList!.insert(tempCommentDataIndex!, tempCommentData!);
        state.notifyListeners();
        tempCommentDataIndex = null;
        tempCommentData = null;
      }
    }

    return result;
  }

  final Map<int, List<CommentData>?> feedStateMap = {};

  void getStateForUser(int contentIdx) {
    state.itemList = feedStateMap[contentIdx] ??
        [
          CommentData(idx: 0, isBadge: 0, memberUuid: '', regDate: '', likeState: 0, uuid: '', nick: '', contents: '', parentIdx: 0, contentsIdx: 0, state: 0),
        ];

    state.notifyListeners();
  }

  void saveStateForUser(int contentIdx) {
    feedStateMap[contentIdx] = state.itemList;
  }
}
