import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_detail_state.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/follow_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/my_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_week_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/recent_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/follow/follow_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/keep_contents/keep_contents_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/like_contents/like_contents_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_list_state_provider.g.dart';

final feedListEmptyProvider = StateProvider<bool>((ref) => true);

@Riverpod(keepAlive: true)
class FeedListState extends _$FeedListState {
  int _lastPage = 0;
  ListAPIStatus apiStatus = ListAPIStatus.idle;

  String? contentType;
  String? searchWord;
  int? idxToRemove;
  int? memberIdx;
  List<MemberInfoListData>? memberInfo;
  String? imgDomain;
  int? loginMemberIdx;

  FeedData? tempFeedData;

  @override
  PagingController<int, FeedData> build() {
    PagingController<int, FeedData> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (apiStatus == ListAPIStatus.loading) {
        return;
      }

      apiStatus = ListAPIStatus.loading;

      FeedResponseModel feedResult = feedNullResponseModel;

      if (contentType == "myContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetailList(loginMemberIdx: loginMemberIdx, memberIdx: memberIdx, page: pageKey);
      } else if (contentType == "myTagContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getMyTagContentsDetailList(loginMemberIdx: loginMemberIdx, page: pageKey);
      } else if (contentType == "userContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserContentsDetailList(loginMemberIdx: loginMemberIdx, page: pageKey, memberIdx: memberIdx);
      } else if (contentType == "userTagContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserTagContentDetail(loginMemberIdx: loginMemberIdx!, page: pageKey, memberIdx: memberIdx!);
      } else if (contentType == "myLikeContent") {
        feedResult = await LikeContentsRepository(dio: ref.read(dioProvider)).getLikeDetailContentList(loginMemberIdx: loginMemberIdx!, page: pageKey);
      } else if (contentType == "mySaveContent") {
        feedResult = await SaveContentsRepository(dio: ref.read(dioProvider)).getSaveDetailContentList(loginMemberIdx: loginMemberIdx!, page: pageKey);
      } else if (contentType == "myDetailContent") {
        feedResult = await Future.value(feedNullResponseModel);
      } else if (contentType == "myKeepContent") {
        feedResult = await Future.value(feedNullResponseModel);
      } else if (contentType == "searchContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserHashtagContentDetailList(
          loginMemberIdx: loginMemberIdx!,
          searchWord: searchWord!,
          page: pageKey,
        );
      } else if (contentType == "popularWeekContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getPopularWeekDetailList(
          loginMemberIdx: loginMemberIdx,
          page: pageKey,
        );
      } else if (contentType == "popularHourContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getPopularHourDetailList(
          loginMemberIdx: loginMemberIdx,
          page: pageKey,
        );
      } else if (contentType == "notificationContent") {
        feedResult = await Future.value(feedNullResponseModel);
      }
      memberInfo = feedResult.data.memberInfo;
      print(memberInfo);
      imgDomain = feedResult.data.imgDomain;

      List<FeedData> searchList = feedResult.data.list
          .map(
            (e) => FeedData(
              commentList: e.commentList,
              keepState: e.keepState,
              followState: e.followState,
              isComment: e.isComment,
              memberIdx: e.memberIdx,
              isLike: e.isLike,
              saveState: e.saveState,
              likeState: e.likeState,
              isView: e.isView,
              regDate: e.regDate,
              imageCnt: e.imageCnt,
              uuid: e.uuid,
              memberUuid: e.memberUuid,
              workUuid: e.workUuid,
              walkResultList: e.walkResultList,
              likeCnt: e.likeCnt,
              contents: e.contents,
              location: e.location,
              modifyState: e.modifyState,
              idx: e.idx,
              mentionList: e.mentionList,
              commentCnt: e.commentCnt,
              hashTagList: e.hashTagList,
              memberInfoList: e.memberInfoList,
              imgList: e.imgList,
            ),
          )
          .toList();

      searchList.removeWhere((element) => element.idx == idxToRemove);

      try {
        _lastPage = feedResult.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }
      apiStatus = ListAPIStatus.loaded;
      ref.read(feedListEmptyProvider.notifier).state = searchList.isEmpty;
    } catch (e) {
      apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void feedRefresh(contentIdx, String type) {
    int targetIdx = -1;

    if (ref.read(myFeedStateProvider).itemList != null) {
      targetIdx = ref.read(myFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postLike") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 1,
                likeCnt: ref.read(myFeedStateProvider).itemList![targetIdx].likeCnt! + 1,
              );
        } else if (type == "deleteLike") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 0,
                likeCnt: ref.read(myFeedStateProvider).itemList![targetIdx].likeCnt! - 1,
              );
        } else if (type == "postSave") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 1,
              );
        } else if (type == "deleteSave") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 0,
              );
        } else if (type == "postKeepContents") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 1,
              );
        } else if (type == "deleteOneKeepContents") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(myFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(myFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide") {
          tempFeedData = ref.read(myFeedStateProvider).itemList![targetIdx];
          ref.read(myFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postBlock") {
          ref.read(myFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postContentReport") {
          tempFeedData = ref.read(myFeedStateProvider).itemList![targetIdx];
          ref.read(myFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postFollow") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 1,
              );
        } else if (type == "deleteFollow") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 0,
              );
        }

        ref.read(myFeedStateProvider).notifyListeners();
      }
    }

    if (ref.read(recentFeedStateProvider).itemList != null) {
      targetIdx = ref.read(recentFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postLike") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 1,
                likeCnt: ref.read(recentFeedStateProvider).itemList![targetIdx].likeCnt! + 1,
              );
        } else if (type == "deleteLike") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 0,
                likeCnt: ref.read(recentFeedStateProvider).itemList![targetIdx].likeCnt! - 1,
              );
        } else if (type == "postSave") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 1,
              );
        } else if (type == "deleteSave") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 0,
              );
        } else if (type == "postKeepContents") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 1,
              );
        } else if (type == "deleteOneKeepContents") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(recentFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(recentFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide") {
          tempFeedData = ref.read(myFeedStateProvider).itemList![targetIdx];
          ref.read(recentFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postBlock") {
          ref.read(recentFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postContentReport") {
          tempFeedData = ref.read(myFeedStateProvider).itemList![targetIdx];
          ref.read(recentFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postFollow") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 1,
              );
        } else if (type == "deleteFollow") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 0,
              );
        }

        ref.read(recentFeedStateProvider).notifyListeners();
      }
    }

    if (ref.read(followFeedStateProvider).itemList != null) {
      targetIdx = ref.read(followFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postLike") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 1,
                likeCnt: ref.read(followFeedStateProvider).itemList![targetIdx].likeCnt! + 1,
              );
        } else if (type == "deleteLike") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 0,
                likeCnt: ref.read(followFeedStateProvider).itemList![targetIdx].likeCnt! - 1,
              );
        } else if (type == "postSave") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 1,
              );
        } else if (type == "deleteSave") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 0,
              );
        } else if (type == "postKeepContents") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 1,
              );
        } else if (type == "deleteOneKeepContents") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(followFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(followFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide") {
          tempFeedData = ref.read(followFeedStateProvider).itemList![targetIdx];
          ref.read(followFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postBlock") {
          ref.read(followFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postContentReport") {
          tempFeedData = ref.read(followFeedStateProvider).itemList![targetIdx];
          ref.read(followFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postFollow") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 1,
              );
        } else if (type == "deleteFollow") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 0,
              );
        }

        ref.read(followFeedStateProvider).notifyListeners();
      }
    }

    if (ref.read(popularWeekFeedStateProvider).itemList != null) {
      targetIdx = ref.read(popularWeekFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postLike") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 1,
                likeCnt: ref.read(popularWeekFeedStateProvider).itemList![targetIdx].likeCnt! + 1,
              );
        } else if (type == "deleteLike") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                likeState: 0,
                likeCnt: ref.read(popularWeekFeedStateProvider).itemList![targetIdx].likeCnt! - 1,
              );
        } else if (type == "postSave") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 1,
              );
        } else if (type == "deleteSave") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                saveState: 0,
              );
        } else if (type == "postKeepContents") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 1,
              );
        } else if (type == "deleteOneKeepContents") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(popularWeekFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(popularWeekFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide") {
          tempFeedData = ref.read(popularWeekFeedStateProvider).itemList![targetIdx];
          ref.read(popularWeekFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postBlock") {
          ref.read(popularWeekFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postContentReport") {
          tempFeedData = ref.read(popularWeekFeedStateProvider).itemList![targetIdx];
          ref.read(popularWeekFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postFollow") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 1,
              );
        } else if (type == "deleteFollow") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                followState: 0,
              );
        }

        ref.read(popularWeekFeedStateProvider).notifyListeners();
      }
    }
  }

  Future<ResponseModel> postLike({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).postLike(memberIdx: loginMemberIdx, contentIdx: contentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
              likeState: 1,
              likeCnt: ref.read(firstFeedStateProvider).itemList![targetIdx].likeCnt! + 1,
            );
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          likeState: 1,
          likeCnt: state.itemList![targetIdx].likeCnt! + 1,
        );
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "postLike",
    );

    return result;
  }

  Future<ResponseModel> deleteLike({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).deleteLike(memberIdx: loginMemberIdx, contentsIdx: contentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
              likeState: 0,
              likeCnt: ref.read(firstFeedStateProvider).itemList![targetIdx].likeCnt! - 1,
            );
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          likeState: 0,
          likeCnt: state.itemList![targetIdx].likeCnt! - 1,
        );
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "deleteLike",
    );

    return result;
  }

  Future<ResponseModel> postSave({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).postSave(memberIdx: loginMemberIdx, contentIdx: contentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
              saveState: 1,
            );
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          saveState: 1,
        );
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "postSave",
    );

    return result;
  }

  Future<ResponseModel> deleteSave({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).deleteSave(memberIdx: loginMemberIdx, contentsIdx: contentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
              saveState: 0,
            );
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          saveState: 0,
        );
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "deleteSave",
    );

    return result;
  }

  Future<ResponseModel> postKeepContents({
    required loginMemberIdx,
    required List<int> contentIdxList,
    required contentType,
  }) async {
    final result = await KeepContentsRepository(dio: ref.read(dioProvider)).postKeepContents(memberIdx: loginMemberIdx, idxList: contentIdxList);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdxList[0]) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdxList[0]);

        ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
              keepState: 1,
            );
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdxList[0]);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          keepState: 1,
        );
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdxList[0],
      "postKeepContents",
    );

    return result;
  }

  Future<ResponseModel> deleteOneKeepContents({
    required loginMemberIdx,
    required contentIdx,
    required contentType,
  }) async {
    final result = await KeepContentsRepository(dio: ref.read(dioProvider)).deleteOneKeepContents(memberIdx: loginMemberIdx, idx: contentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
              keepState: 0,
            );
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
          keepState: 0,
        );
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "deleteOneKeepContents",
    );

    return result;
  }

  Future<ResponseModel> deleteOneContents({
    required loginMemberIdx,
    required int contentIdx,
    required contentType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).deleteOneContents(memberIdx: loginMemberIdx, idx: contentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList!.removeAt(targetIdx);
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "deleteOneContents",
    );

    return result;
  }

  Future<ResponseModel> postHide({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).postHide(memberIdx: loginMemberIdx, contentIdx: contentIdx);

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        tempFeedData = ref.read(firstFeedStateProvider).itemList![targetIdx];

        ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        tempFeedData = state.itemList![targetIdx];

        state.itemList!.removeAt(targetIdx);
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "postHide",
    );

    return result;
  }

  Future<ResponseModel> deleteHide({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).deleteHide(memberIdx: loginMemberIdx, contentsIdx: contentIdx);

    state.itemList?.add(tempFeedData!);

    tempFeedData = null;

    return result;
  }

  Future<ResponseModel> postBlock({
    required memberIdx,
    required blockIdx,
    required contentIdx,
    required contentType,
  }) async {
    final result = await BlockRepository(dio: ref.read(dioProvider)).postBlock(
      memberIdx: memberIdx,
      blockIdx: blockIdx,
    );

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList!.removeAt(targetIdx);
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "postBlock",
    );

    return result;
  }

  Future<ResponseModel> postContentReport({
    required int loginMemberIdx,
    required int contentIdx,
    required int reportCode,
    required String? reason,
    required String reportType,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).postContentReport(
      reportType: reportType,
      memberIdx: loginMemberIdx,
      contentIdx: contentIdx,
      reportCode: reportCode,
      reason: reason,
    );

    int targetIdx = -1;

    if (state.itemList != null) {
      if (idxToRemove == contentIdx) {
        targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

        tempFeedData = ref.read(firstFeedStateProvider).itemList![targetIdx];

        ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        tempFeedData = state.itemList![targetIdx];

        state.itemList!.removeAt(targetIdx);
        state.notifyListeners();
      }
    }

    feedRefresh(
      contentIdx,
      "postContentReport",
    );

    return result;
  }

  Future<ResponseModel> deleteContentReport({
    required String reportType,
    required int loginMemberIdx,
    required int contentIdx,
  }) async {
    final result = await FeedRepository(dio: ref.read(dioProvider)).deleteContentReport(
      reportType: reportType,
      memberIdx: loginMemberIdx,
      contentsIdx: contentIdx,
    );

    state.itemList?.add(tempFeedData!);

    tempFeedData = null;

    return result;
  }

  // Future<ResponseModel> postFollow({
  //   required memberIdx,
  //   required followIdx,
  //   required contentsIdx,
  //   required contentType,
  // }) async {
  //   final result = await FollowRepository(dio: ref.read(dioProvider)).postFollow(memberIdx: memberIdx, followIdx: followIdx);
  //
  //   int targetIdx = -1;
  //
  //   if (state.itemList != null) {
  //     if (idxToRemove == contentsIdx) {
  //       targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentsIdx);
  //
  //       ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
  //             followState: 1,
  //           );
  //       ref.read(firstFeedStateProvider).notifyListeners();
  //     }
  //
  //     targetIdx = state.itemList!.indexWhere((element) => element.idx == contentsIdx);
  //
  //     if (targetIdx != -1) {
  //       state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
  //         followState: 1,
  //       );
  //       state.notifyListeners();
  //     }
  //   }
  //
  //   feedRefresh(
  //     contentsIdx,
  //     "postFollow",
  //   );
  //
  //   return result;
  // }
  //
  // Future<ResponseModel> deleteFollow({
  //   required memberIdx,
  //   required followIdx,
  //   required contentsIdx,
  //   required contentType,
  // }) async {
  //   final result = await FollowRepository(dio: ref.read(dioProvider)).deleteFollow(memberIdx: memberIdx, followIdx: followIdx);
  //
  //   int targetIdx = -1;
  //
  //   if (state.itemList != null) {
  //     if (idxToRemove == contentsIdx) {
  //       targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentsIdx);
  //
  //       ref.read(firstFeedStateProvider).itemList![targetIdx] = ref.read(firstFeedStateProvider).itemList![targetIdx].copyWith(
  //             followState: 0,
  //           );
  //       ref.read(firstFeedStateProvider).notifyListeners();
  //     }
  //
  //     targetIdx = state.itemList!.indexWhere((element) => element.idx == contentsIdx);
  //
  //     if (targetIdx != -1) {
  //       state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
  //         followState: 0,
  //       );
  //       state.notifyListeners();
  //     }
  //   }
  //
  //   feedRefresh(
  //     contentsIdx,
  //     "deleteFollow",
  //   );
  //
  //   return result;
  // }

  final Map<int, List<FeedData>?> feedStateMap = {};
  final Map<int, List<MemberInfoListData>?> feedMemberInfoStateMap = {};

  void getStateForUser(int? userId) {
    state.itemList = feedStateMap[userId ?? 0] ?? [FeedData(idx: 0)];
    memberInfo = feedMemberInfoStateMap[userId ?? 0] ?? [MemberInfoListData()];

    state.notifyListeners();
  }

  void saveStateForUser(int? userId) {
    feedStateMap[userId ?? 0] = state.itemList;
    feedMemberInfoStateMap[userId ?? 0] = memberInfo;
  }
}
