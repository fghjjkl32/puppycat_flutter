import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/follow_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/my_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_week_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/recent_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/my_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/user_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/my_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/keep_contents/keep_contents_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/like_contents/like_contents_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_list_state_provider.g.dart';

final likeApiIsLoadingStateProvider = StateProvider<bool>((ref) => false);
final saveApiIsLoadingStateProvider = StateProvider<bool>((ref) => false);

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
  ContentImageData? tempContentImageData;

  int? tempFeedDataIndex;
  int? tempFirstFeedDataIndex;
  int? tempRecentFeedIndex;
  int? tempMyFeedDataIndex;
  int? tempFollowFeedDataIndex;
  int? tempPopularWeekFeedDataIndex;
  int? tempContentImageDataIndex;
  int? tempTagContentImageDataIndex;

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
      } else if (contentType == "userContent" || contentType == "FollowCardContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserContentsDetailList(loginMemberIdx: loginMemberIdx, page: pageKey, memberIdx: memberIdx);
      } else if (contentType == "userTagContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserTagContentDetail(loginMemberIdx: loginMemberIdx, page: pageKey, memberIdx: memberIdx!);
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
          loginMemberIdx: loginMemberIdx,
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
        _lastPage = feedResult.data.params!.pagination?.totalPageCount! ?? 0;
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
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      apiStatus = ListAPIStatus.error;
      state.error = apiException.toString();
    } catch (e) {
      apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void feedRefresh(contentIdx, String type) {
    int targetIdx = -1;

    if (ref.read(myFeedStateProvider).itemList != null) {
      if (type == "deleteHide" || type == "deleteContentReport") {
        if (tempFeedData != null && tempMyFeedDataIndex != null) {
          ref.read(myFeedStateProvider).itemList!.insert(tempMyFeedDataIndex!, tempFeedData!);
          tempMyFeedDataIndex = null;
        }
      } else if (type == "postBlock") {
        ref.read(myFeedStateProvider).itemList!.removeWhere((element) => element.memberIdx == contentIdx);
      }

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
          ref.read(myFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(myFeedStateProvider).itemList![targetIdx] = ref.read(myFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(myFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide" || type == "postContentReport") {
          tempFeedData = ref.read(myFeedStateProvider).itemList![targetIdx];
          tempMyFeedDataIndex = targetIdx;
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
      if (type == "deleteHide" || type == "deleteContentReport") {
        if (tempFeedData != null && tempRecentFeedIndex != null) {
          ref.read(recentFeedStateProvider).itemList!.insert(tempRecentFeedIndex!, tempFeedData!);
          tempRecentFeedIndex = null;
        }
      } else if (type == "postBlock") {
        ref.read(recentFeedStateProvider).itemList!.removeWhere((element) => element.memberIdx == contentIdx);
      }

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
          ref.read(recentFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(recentFeedStateProvider).itemList![targetIdx] = ref.read(recentFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(recentFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide" || type == "postContentReport") {
          tempFeedData = ref.read(recentFeedStateProvider).itemList![targetIdx];
          tempRecentFeedIndex = targetIdx;
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
      if (type == "deleteHide" || type == "deleteContentReport") {
        if (tempFeedData != null && tempFollowFeedDataIndex != null) {
          ref.read(followFeedStateProvider).itemList!.insert(tempFollowFeedDataIndex!, tempFeedData!);
          tempFollowFeedDataIndex = null;
        }
      } else if (type == "postBlock") {
        ref.read(followFeedStateProvider).itemList!.removeWhere((element) => element.memberIdx == contentIdx);
      }

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
          ref.read(followFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(followFeedStateProvider).itemList![targetIdx] = ref.read(followFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(followFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide" || type == "postContentReport") {
          tempFeedData = ref.read(followFeedStateProvider).itemList![targetIdx];
          tempFollowFeedDataIndex = targetIdx;
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
      if (type == "deleteHide" || type == "deleteContentReport") {
        if (tempFeedData != null && tempPopularWeekFeedDataIndex != null) {
          ref.read(popularWeekFeedStateProvider).itemList!.insert(tempPopularWeekFeedDataIndex!, tempFeedData!);
          tempPopularWeekFeedDataIndex = null;
        }
      } else if (type == "postBlock") {
        ref.read(popularWeekFeedStateProvider).itemList!.removeWhere((element) => element.memberIdx == contentIdx);
      }

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
          ref.read(popularWeekFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneKeepContents") {
          ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = ref.read(popularWeekFeedStateProvider).itemList![targetIdx].copyWith(
                keepState: 0,
              );
        } else if (type == "deleteOneContents") {
          ref.read(popularWeekFeedStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "postHide" || type == "postContentReport") {
          tempFeedData = ref.read(popularWeekFeedStateProvider).itemList![targetIdx];
          tempPopularWeekFeedDataIndex = targetIdx;
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

    if (ref.read(myContentsStateProvider).itemList != null) {
      targetIdx = ref.read(myContentsStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postLike") {
          ref.read(myContentsStateProvider).itemList![targetIdx] = ref.read(myContentsStateProvider).itemList![targetIdx].copyWith(
                selfLike: 1,
                likeCnt: ref.read(myContentsStateProvider).itemList![targetIdx].likeCnt! + 1,
              );
        } else if (type == "deleteLike") {
          ref.read(myContentsStateProvider).itemList![targetIdx] = ref.read(myContentsStateProvider).itemList![targetIdx].copyWith(
                selfLike: 0,
                likeCnt: ref.read(myContentsStateProvider).itemList![targetIdx].likeCnt! - 1,
              );
        } else if (type == "postKeepContents") {
          ref.read(myContentsStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneContents") {
          ref.read(myContentsStateProvider).itemList!.removeAt(targetIdx);
        }

        ref.read(myContentsStateProvider).notifyListeners();
      }
    }
    if (ref.read(myTagContentsStateProvider).itemList != null) {
      targetIdx = ref.read(myTagContentsStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postKeepContents") {
          ref.read(myTagContentsStateProvider).itemList!.removeAt(targetIdx);
        } else if (type == "deleteOneContents") {
          ref.read(myTagContentsStateProvider).itemList!.removeAt(targetIdx);
        }

        ref.read(myTagContentsStateProvider).notifyListeners();
      }
    }

    if (ref.read(userContentsStateProvider).itemList != null) {
      if (type == "deleteHide" || type == "deleteContentReport") {
        if (tempContentImageData != null && tempContentImageDataIndex != null) {
          ref.read(userContentsStateProvider).itemList!.insert(tempContentImageDataIndex!, tempContentImageData!);
          tempContentImageDataIndex = null;
        }
      } else if (type == "postBlock") {
        ref.read(userContentsStateProvider).itemList!.clear();
        ref.read(userTagContentsStateProvider).itemList!.clear();
      }

      targetIdx = ref.read(userContentsStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postHide" || type == "postContentReport") {
          tempContentImageData = ref.read(userContentsStateProvider).itemList![targetIdx];
          tempContentImageDataIndex = targetIdx;
          ref.read(userContentsStateProvider).itemList!.removeAt(targetIdx);
        }
      }

      ref.read(userContentsStateProvider).notifyListeners();
    }

    if (ref.read(userTagContentsStateProvider).itemList != null) {
      if (type == "deleteHide" || type == "deleteContentReport") {
        if (tempContentImageData != null && tempTagContentImageDataIndex != null) {
          ref.read(userTagContentsStateProvider).itemList!.insert(tempTagContentImageDataIndex!, tempContentImageData!);
          tempTagContentImageDataIndex = null;
        }
      } else if (type == "postBlock") {
        ref.read(userTagContentsStateProvider).itemList!.clear();
        ref.read(userContentsStateProvider).itemList!.clear();
      }

      targetIdx = ref.read(userTagContentsStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postHide" || type == "postContentReport") {
          tempContentImageData = ref.read(userTagContentsStateProvider).itemList![targetIdx];
          tempTagContentImageDataIndex = targetIdx;
          ref.read(userTagContentsStateProvider).itemList!.removeAt(targetIdx);
        }
      }

      ref.read(userTagContentsStateProvider).notifyListeners();
    }
  }

  Future<ResponseModel> postLike({
    required loginMemberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    ref.read(likeApiIsLoadingStateProvider.notifier).state = true;

    try {
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

      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('postLike error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteLike({
    required loginMemberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    ref.read(likeApiIsLoadingStateProvider.notifier).state = true;

    try {
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

      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('deleteLike error $e');
      rethrow;
    }
  }

  Future<ResponseModel> postSave({
    required loginMemberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    ref.read(saveApiIsLoadingStateProvider.notifier).state = true;

    try {
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

      ref.read(saveApiIsLoadingStateProvider.notifier).state = false;

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('postSave error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteSave({
    required loginMemberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    ref.read(saveApiIsLoadingStateProvider.notifier).state = true;

    try {
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

      ref.read(saveApiIsLoadingStateProvider.notifier).state = false;

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('delete save error $e');
      rethrow;
    }
  }

  Future<ResponseModel> postKeepContents({
    required loginMemberIdx,
    required List<int> contentIdxList,
    required contentType,
  }) async {
    try {
      final result = await KeepContentsRepository(dio: ref.read(dioProvider)).postKeepContents(memberIdx: loginMemberIdx, idxList: contentIdxList);

      int targetIdx = -1;

      if (state.itemList != null) {
        if (idxToRemove == contentIdxList[0]) {
          targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdxList[0]);

          ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
          ref.read(firstFeedEmptyProvider.notifier).state = true;
          ref.read(firstFeedStateProvider).notifyListeners();
        }

        targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdxList[0]);

        if (targetIdx != -1) {
          state.itemList!.removeAt(targetIdx);
          state.notifyListeners();
        }
      }

      feedRefresh(
        contentIdxList[0],
        "postKeepContents",
      );

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('postKeepContents error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteOneKeepContents({
    required loginMemberIdx,
    required contentIdx,
    required contentType,
  }) async {
    try {
      final result = await KeepContentsRepository(dio: ref.read(dioProvider)).deleteOneKeepContents(memberIdx: loginMemberIdx, idx: contentIdx);

      int targetIdx = -1;

      if (state.itemList != null) {
        if (idxToRemove == contentIdx) {
          targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

          ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
          ref.read(firstFeedEmptyProvider.notifier).state = true;

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
        "deleteOneKeepContents",
      );

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('deleteOneKeepContents error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteOneContents({
    required loginMemberIdx,
    required int contentIdx,
    required contentType,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteOneContents(memberIdx: loginMemberIdx, idx: contentIdx);

      int targetIdx = -1;

      if (state.itemList != null) {
        if (idxToRemove == contentIdx) {
          targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

          ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
          ref.read(firstFeedEmptyProvider.notifier).state = true;

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
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('deleteOneContents error $e');
      rethrow;
    }
  }

  Future<ResponseModel> postHide({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).postHide(memberIdx: loginMemberIdx, contentIdx: contentIdx);

      int targetIdx = -1;

      if (state.itemList != null) {
        if (idxToRemove == contentIdx) {
          targetIdx = ref.read(firstFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

          tempFirstFeedDataIndex = targetIdx;

          tempFeedData = ref.read(firstFeedStateProvider).itemList![targetIdx];

          ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
          ref.read(firstFeedEmptyProvider.notifier).state = true;

          ref.read(firstFeedStateProvider).notifyListeners();
        }

        targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

        tempFeedDataIndex = targetIdx;

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
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('postHide error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteHide({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteHide(memberIdx: loginMemberIdx, contentsIdx: contentIdx);

      if (state.itemList != null) {
        if (tempFirstFeedDataIndex != null) {
          ref.read(firstFeedStateProvider).itemList!.insert(tempFirstFeedDataIndex!, tempFeedData!);
          ref.read(firstFeedStateProvider).notifyListeners();
          tempFirstFeedDataIndex = null;
        }

        if (tempFeedDataIndex != null && tempFeedDataIndex != -1) {
          state.itemList!.insert(tempFeedDataIndex!, tempFeedData!);
          state.notifyListeners();
          tempFeedDataIndex = null;
        }
      }

      feedRefresh(
        contentIdx,
        "deleteHide",
      );

      tempFeedData = null;

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('deleteHide error $e');
      rethrow;
    }
  }

  Future<ResponseModel> postBlock({
    required memberIdx,
    required blockIdx,
    required contentType,
  }) async {
    try {
      final result = await BlockRepository(dio: ref.read(dioProvider)).postBlock(
        memberIdx: memberIdx,
        blockIdx: blockIdx,
      );

      if (state.itemList != null) {
        state.itemList!.removeWhere((element) => element.memberIdx == blockIdx);
        state.notifyListeners();

        ref.read(firstFeedStateProvider).itemList!.removeWhere((element) => element.memberIdx == blockIdx);
        ref.read(firstFeedStateProvider).notifyListeners();
      }

      feedRefresh(
        blockIdx,
        "postBlock",
      );

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('notification setFeedLike error $e');
      rethrow;
    }
  }

  Future<ResponseModel> postContentReport({
    required int loginMemberIdx,
    required int contentIdx,
    required int reportCode,
    required String? reason,
    required String reportType,
  }) async {
    try {
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

          tempFirstFeedDataIndex = targetIdx;

          tempFeedData = ref.read(firstFeedStateProvider).itemList![targetIdx];

          ref.read(firstFeedStateProvider).itemList!.removeAt(targetIdx);
          ref.read(firstFeedEmptyProvider.notifier).state = true;

          ref.read(firstFeedStateProvider).notifyListeners();
        }

        targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

        tempFeedDataIndex = targetIdx;

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
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('postContentReport error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteContentReport({
    required String reportType,
    required int loginMemberIdx,
    required int contentIdx,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteContentReport(
        reportType: reportType,
        memberIdx: loginMemberIdx,
        contentsIdx: contentIdx,
      );

      if (state.itemList != null) {
        if (tempFirstFeedDataIndex != null) {
          ref.read(firstFeedStateProvider).itemList!.insert(tempFirstFeedDataIndex!, tempFeedData!);
          ref.read(firstFeedStateProvider).notifyListeners();
          tempFirstFeedDataIndex = null;
        }

        if (tempFeedDataIndex != null && tempFeedDataIndex != -1) {
          state.itemList!.insert(tempFeedDataIndex!, tempFeedData!);
          state.notifyListeners();
          tempFeedDataIndex = null;
        }
      }

      feedRefresh(
        contentIdx,
        "deleteContentReport",
      );

      tempFeedData = null;

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('deleteContentReport error $e');
      rethrow;
    }
  }

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
