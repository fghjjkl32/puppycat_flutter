import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_image_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/follow_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/my_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/popular_hour_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/popular_week_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/recent_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/notification_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/tag_contents/my_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/tag_contents/user_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_contents/my_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_list/popular_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/feed/feed_repository.dart';
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
  int? firstFeedIdx;
  String? memberUuid;
  MemberInfoData? memberInfo;

  FeedData? tempFeedData;
  ContentImageData? tempContentImageData;

  int? tempFeedDataIndex;

  // int? tempFirstFeedDataIndex;
  bool isFirstFeedHidden = false;
  int? tempRecentFeedIndex;
  int? tempMyFeedDataIndex;
  int? tempFollowFeedDataIndex;
  int? tempPopularWeekFeedDataIndex;
  int? tempContentImageDataIndex;
  int? tempTagContentImageDataIndex;

  Map<int, bool> _initialLikeStates = {};
  int? saveLike;

  Map<int, bool> _initialKeepStates = {};
  int? saveKeep;

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

      FeedResponseModel? feedResult; // = feedNullResponseModel;

      if (contentType == "myContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetailList(page: pageKey);
      } else if (contentType == "myTagContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getMyTagContentsDetailList(page: pageKey);
      } else if (contentType == "userContent" || contentType == "FollowCardContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserContentsDetailList(memberUuid: memberUuid!, page: pageKey);
      } else if (contentType == "userTagContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserTagContentDetail(memberUuid: memberUuid!, page: pageKey);
      } else if (contentType == "myLikeContent") {
        feedResult = await LikeContentsRepository(dio: ref.read(dioProvider)).getLikeDetailContentList(page: pageKey);
      } else if (contentType == "mySaveContent") {
        feedResult = await SaveContentsRepository(dio: ref.read(dioProvider)).getSaveDetailContentList(page: pageKey);
      } else if (contentType == "myDetailContent") {
        feedResult = await Future.value(feedNullResponseModel);
      } else if (contentType == "myKeepContent") {
        feedResult = await Future.value(feedNullResponseModel);
      } else if (contentType == "searchContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getUserHashtagContentDetailList(
          searchWord: searchWord!,
          page: pageKey,
        );
      } else if (contentType == "popularWeekContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getPopularWeekDetailList(
          page: pageKey,
        );
      } else if (contentType == "popularHourContent") {
        feedResult = await FeedRepository(dio: ref.read(dioProvider)).getPopularHourDetailList(
          page: pageKey,
        );
      } else if (contentType == "notificationContent") {
        feedResult = await Future.value(feedNullResponseModel);
      }

      if (feedResult == null) {
        throw APIException(
          msg: 'feedResult is null',
          code: '400',
          refer: 'FeedListState',
          caller: '_fetchPage',
        );
      }

      memberInfo = feedResult.data!.memberInfo;

      List<dynamic> resultList = feedResult.data!.list;
      List<FeedData> searchList = resultList.map((e) {
        FeedData feedDetail = FeedData.fromJson(e);
        return feedDetail;
      }).toList();

      searchList.removeWhere((element) => element.idx == firstFeedIdx);

      try {
        _lastPage = feedResult.data!.params!.pagination?.totalPageCount! ?? 0;
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
      print('FeedListState fetch error $e');
      apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void feedRefresh(contentIdx, String type, {FeedData? editData}) {
    int targetIdx = -1;

    if (ref.read(myFeedStateProvider).itemList != null) {
      if (type == "deleteHide" || type == "deleteContentReport") {
        if (tempFeedData != null && tempMyFeedDataIndex != null) {
          ref.read(myFeedStateProvider).itemList!.insert(tempMyFeedDataIndex!, tempFeedData!);
          tempMyFeedDataIndex = null;
        }
      } else if (type == "postBlock") {
        ref.read(myFeedStateProvider).itemList!.removeWhere((element) => element.memberUuid == contentIdx);
      }

      targetIdx = ref.read(myFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postKeepContents") {
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
        ref.read(recentFeedStateProvider).itemList!.removeWhere((element) => element.memberUuid == contentIdx);
      }

      targetIdx = ref.read(recentFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postKeepContents") {
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
        ref.read(followFeedStateProvider).itemList!.removeWhere((element) => element.memberUuid == contentIdx);
      }

      targetIdx = ref.read(followFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postKeepContents") {
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
        ref.read(popularWeekFeedStateProvider).itemList!.removeWhere((element) => element.memberUuid == contentIdx);
      }

      targetIdx = ref.read(popularWeekFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (type == "postKeepContents") {
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
        if (type == "postKeepContents") {
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

  void editFeedRefresh({
    required int contentIdx,
    required FeedData editData,
  }) async {
    int targetIdx = -1;

    if (state.itemList != null) {
      if (firstFeedIdx == contentIdx) {
        final firstFeedData = ref.read(firstFeedDetailStateProvider);
        if (firstFeedData != null) {
          if (firstFeedData.idx == contentIdx) {
            ref.read(firstFeedDetailStateProvider.notifier).state = editData;
          }
        }
      }

      targetIdx = state.itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        state.itemList![targetIdx] = editData;

        state.notifyListeners();
      }
    }

    if (ref.read(myFeedStateProvider).itemList != null) {
      targetIdx = ref.read(myFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        ref.read(myFeedStateProvider).itemList![targetIdx] = editData;

        ref.read(myFeedStateProvider).notifyListeners();
      }
    }

    if (ref.read(recentFeedStateProvider).itemList != null) {
      targetIdx = ref.read(recentFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        ref.read(recentFeedStateProvider).itemList![targetIdx] = editData;

        ref.read(recentFeedStateProvider).notifyListeners();
      }
    }

    if (ref.read(followFeedStateProvider).itemList != null) {
      targetIdx = ref.read(followFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        ref.read(followFeedStateProvider).itemList![targetIdx] = editData;

        ref.read(followFeedStateProvider).notifyListeners();
      }
    }

    if (ref.read(popularWeekFeedStateProvider).itemList != null) {
      targetIdx = ref.read(popularWeekFeedStateProvider).itemList!.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        ref.read(popularWeekFeedStateProvider).itemList![targetIdx] = editData;

        ref.read(popularWeekFeedStateProvider).notifyListeners();
      }
    }
  }

  Future<ResponseModel> postLike({
    required contentIdx,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).postLike(contentIdx: contentIdx);

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
    required contentIdx,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteLike(contentsIdx: contentIdx);

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
    required contentIdx,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).postSave(contentIdx: contentIdx);

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
    required contentIdx,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteSave(contentsIdx: contentIdx);

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
    required List<int> contentIdxList,
    required contentType,
  }) async {
    try {
      final result = await KeepContentsRepository(dio: ref.read(dioProvider)).postKeepContents(idxList: contentIdxList);

      int targetIdx = -1;

      if (state.itemList != null) {
        if (firstFeedIdx == contentIdxList[0]) {
          final firstFeedData = ref.read(firstFeedDetailStateProvider);
          if (firstFeedData != null) {
            if (firstFeedData.idx == contentIdxList[0]) {
              ref.read(firstFeedDetailStateProvider.notifier).state = null;
              ref.read(firstFeedEmptyProvider.notifier).state = true;
            }
          }
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
    required int contentIdx,
    required contentType,
  }) async {
    try {
      final result = await KeepContentsRepository(dio: ref.read(dioProvider)).deleteOneKeepContents(idx: contentIdx);

      int targetIdx = -1;

      if (state.itemList != null) {
        if (firstFeedIdx == contentIdx) {
          final firstFeedData = ref.read(firstFeedDetailStateProvider);
          if (firstFeedData != null) {
            if (firstFeedData.idx == contentIdx) {
              ref.read(firstFeedDetailStateProvider.notifier).state = null;
              ref.read(firstFeedEmptyProvider.notifier).state = true;
            }
          }
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
    required int contentIdx,
    required contentType,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteOneContents(idx: contentIdx);

      int targetIdx = -1;

      if (state.itemList != null) {
        if (firstFeedIdx == contentIdx) {
          final firstFeedData = ref.read(firstFeedDetailStateProvider);
          if (firstFeedData != null) {
            if (firstFeedData.idx == contentIdx) {
              ref.read(firstFeedDetailStateProvider.notifier).state = null;
              ref.read(firstFeedEmptyProvider.notifier).state = true;
            }
          }
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
    required contentIdx,
    required String contentType,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).postHide(contentIdx: contentIdx);

      int targetIdx = -1;

      ref.read(popularUserListStateProvider.notifier).getInitUserList();

      ref.read(popularHourFeedStateProvider.notifier).initPosts();

      if (state.itemList != null) {
        if (firstFeedIdx == contentIdx) {
          final firstFeedData = ref.read(firstFeedDetailStateProvider);
          if (firstFeedData != null) {
            if (firstFeedData.idx == contentIdx) {
              isFirstFeedHidden = true;
              tempFeedData = firstFeedData;

              ref.read(firstFeedDetailStateProvider.notifier).state = null;
              ref.read(firstFeedEmptyProvider.notifier).state = true;
            }
          }
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
    required contentIdx,
    required String contentType,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteHide(contentsIdx: contentIdx);

      ref.read(popularUserListStateProvider.notifier).getInitUserList();

      ref.read(popularHourFeedStateProvider.notifier).initPosts();

      if (state.itemList != null) {
        if (isFirstFeedHidden) {
          ref.read(firstFeedDetailStateProvider.notifier).state = tempFeedData;
          isFirstFeedHidden = false;
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
    required String blockUuid,
    String contentType = '',
  }) async {
    try {
      final result = await BlockRepository(dio: ref.read(dioProvider)).postBlock(
        blockUuid: blockUuid,
      );

      ref.read(popularUserListStateProvider.notifier).getInitUserList();

      ref.read(popularHourFeedStateProvider.notifier).initPosts();

      if (state.itemList != null) {
        state.itemList!.removeWhere((element) => element.memberUuid == blockUuid);
        state.notifyListeners();

        final firstFeedData = ref.read(firstFeedDetailStateProvider);
        if (firstFeedData != null) {
          if (firstFeedData.memberUuid == blockUuid) {
            ref.read(firstFeedDetailStateProvider.notifier).state = null;
            ref.read(firstFeedEmptyProvider.notifier).state = true;
          }
        }
      }

      feedRefresh(
        blockUuid,
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
    required int contentIdx,
    required int reportCode,
    required String? reason,
    required String reportType,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).postContentReport(
        reportType: reportType,
        contentIdx: contentIdx,
        reportCode: reportCode,
        reason: reason,
      );

      ref.read(popularUserListStateProvider.notifier).getInitUserList();

      ref.read(popularHourFeedStateProvider.notifier).initPosts();

      int targetIdx = -1;

      if (state.itemList != null) {
        if (firstFeedIdx == contentIdx) {
          final firstFeedData = ref.read(firstFeedDetailStateProvider);
          if (firstFeedData != null) {
            if (firstFeedData.idx == contentIdx) {
              isFirstFeedHidden = true;
              tempFeedData = firstFeedData;
              ref.read(firstFeedDetailStateProvider.notifier).state = null;
              ref.read(firstFeedEmptyProvider.notifier).state = true;
            }
          }
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
    required int contentIdx,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteContentReport(
        reportType: reportType,
        contentsIdx: contentIdx,
      );

      ref.read(popularUserListStateProvider.notifier).getInitUserList();

      ref.read(popularHourFeedStateProvider.notifier).initPosts();

      if (state.itemList != null) {
        if (isFirstFeedHidden) {
          ref.read(firstFeedDetailStateProvider.notifier).state = tempFeedData;
          isFirstFeedHidden = false;
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

  final Map<String, List<FeedData>?> feedStateMap = {};
  final Map<String, MemberInfoData?> feedMemberInfoStateMap = {};

  void getStateForUser(String memberUuid) {
    state.itemList = feedStateMap[memberUuid] ?? [FeedData(idx: 0)];
    memberInfo = feedMemberInfoStateMap[memberUuid] ?? MemberInfoData();

    state.notifyListeners();
  }

  void saveStateForUser(String memberUuid) {
    feedStateMap[memberUuid] = state.itemList;
    feedMemberInfoStateMap[memberUuid] = memberInfo;
  }

  Future<void> toggleLike({
    required int contentIdx,
  }) async {
    List<FeedData>? currentList = state.itemList;
    int targetIdx = -1;

    if (ref.read(firstFeedDetailStateProvider) != null && currentList != null) {
      if (firstFeedIdx == contentIdx) {
        // 좋아요 상태를 변경하기 전의 상태를 저장합니다.
        if (!_initialLikeStates.containsKey(contentIdx)) {
          _initialLikeStates[contentIdx] = ref.read(firstFeedDetailStateProvider)!.likeState == 1;
        }

        bool isFirstFeedCurrentlyLiked = ref.read(firstFeedDetailStateProvider)!.likeState == 1;

        if (ref.read(firstFeedDetailStateProvider)!.idx == contentIdx) {
          // 좋아요 상태를 토글합니다.
          ref.read(firstFeedDetailStateProvider.notifier).state = ref.read(firstFeedDetailStateProvider)!.copyWith(
                likeState: isFirstFeedCurrentlyLiked ? 0 : 1,
                likeCnt: isFirstFeedCurrentlyLiked ? ref.read(firstFeedDetailStateProvider)!.likeCnt! - 1 : ref.read(firstFeedDetailStateProvider)!.likeCnt! + 1,
              );

          state.notifyListeners();

          saveLike = ref.read(firstFeedDetailStateProvider)!.likeState;
        }
      }

      targetIdx = currentList.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        // 좋아요 상태를 변경하기 전의 상태를 저장합니다.
        if (!_initialLikeStates.containsKey(contentIdx)) {
          _initialLikeStates[contentIdx] = currentList[targetIdx].likeState == 1;
        }

        bool isCurrentlyLiked = currentList[targetIdx].likeState == 1;
        currentList[targetIdx] = currentList[targetIdx].copyWith(
          likeState: isCurrentlyLiked ? 0 : 1,
          likeCnt: isCurrentlyLiked ? currentList[targetIdx].likeCnt! - 1 : currentList[targetIdx].likeCnt! + 1,
        );

        state.notifyListeners();

        saveLike = currentList[targetIdx].likeState;
      }
    }

    // 각 프로바이더에 대해 추출된 함수 호출
    updateLikeStateForProvider(myFeedStateProvider, contentIdx);
    updateLikeStateForProvider(recentFeedStateProvider, contentIdx);
    updateLikeStateForProvider(followFeedStateProvider, contentIdx);
    updateLikeStateForProvider(popularWeekFeedStateProvider, contentIdx);
    updateLikeStateForProvider(myContentsStateProvider, contentIdx);
    updateLikeStateForProvider(notificationListStateProvider, contentIdx);

    handleLikeAction(
      contentIdx: contentIdx,
      likeState: saveLike,
    );
  }

  // 각 프로바이더에 대해 반복되는 로직을 처리하는 함수
  void updateLikeStateForProvider(
    ProviderBase provider,
    int contentIdx,
  ) {
    // myContentsStateProvider의 경우 selfLike 필드를 업데이트합니다.
    // notificationListStateProvider의 경우 contentsLikeState 필드를 업데이트합니다.

    var itemList = ref.read(provider).itemList;
    if (itemList != null) {
      int targetIdx;

      if (provider == notificationListStateProvider) {
        targetIdx = itemList.indexWhere((element) => element.contentsIdx == contentIdx);
      } else {
        targetIdx = itemList.indexWhere((element) => element.idx == contentIdx);
      }

      if (targetIdx != -1) {
        if (!_initialLikeStates.containsKey(contentIdx)) {
          if (provider == myContentsStateProvider) {
            _initialLikeStates[contentIdx] = itemList[targetIdx].selfLike == 1;
          } else if (provider == notificationListStateProvider) {
            _initialLikeStates[contentIdx] = itemList[targetIdx].contentsLikeState == 1;
          } else {
            _initialLikeStates[contentIdx] = itemList[targetIdx].likeState == 1;
          }
        }

        bool isCurrentlyLiked;

        if (provider == myContentsStateProvider) {
          isCurrentlyLiked = itemList[targetIdx].selfLike == 1;
        } else if (provider == notificationListStateProvider) {
          isCurrentlyLiked = itemList[targetIdx].contentsLikeState == 1;
        } else {
          isCurrentlyLiked = itemList[targetIdx].likeState == 1;
        }

        if (provider == myContentsStateProvider) {
          itemList[targetIdx] = itemList[targetIdx].copyWith(
            selfLike: isCurrentlyLiked ? 0 : 1,
            likeCnt: isCurrentlyLiked ? itemList[targetIdx].likeCnt - 1 : itemList[targetIdx].likeCnt + 1,
          );
        } else if (provider == notificationListStateProvider) {
          itemList[targetIdx] = itemList[targetIdx].copyWith(
            contentsLikeState: isCurrentlyLiked ? 0 : 1,
          );
        } else {
          itemList[targetIdx] = itemList[targetIdx].copyWith(
            likeState: isCurrentlyLiked ? 0 : 1,
            likeCnt: isCurrentlyLiked ? itemList[targetIdx].likeCnt - 1 : itemList[targetIdx].likeCnt + 1,
          );
        }

        ref.read(provider).notifyListeners();

        if (provider == myContentsStateProvider) {
          saveLike = itemList[targetIdx].selfLike;
        } else if (provider == notificationListStateProvider) {
          saveLike = itemList[targetIdx].contentsLikeState;
        } else {
          saveLike = itemList[targetIdx].likeState;
        }
      }
    }
  }

  void handleLikeAction({
    required int contentIdx,
    required int? likeState,
  }) {
    // 디바운스 타이머 설정

    EasyDebounce.debounce(
      'handleLikeAction',
      const Duration(
        milliseconds: 500,
      ),
      () async {
        // 초기 상태와 현재 상태를 비교합니다.
        bool initialLikeState = _initialLikeStates[contentIdx] ?? false;
        if (likeState == 1 && !initialLikeState) {
          // 좋아요 상태가 되었다면 API 호출
          await postLike(contentIdx: contentIdx);
        } else if (likeState == 0 && initialLikeState) {
          // 좋아요 취소 상태가 되었다면 API 호출
          await deleteLike(contentIdx: contentIdx);
        }
        // 처리 후 초기 상태 정보 삭제
        _initialLikeStates.remove(contentIdx);
        saveLike = null;
      },
    );
  }

  Future<void> toggleSave({
    required int contentIdx,
  }) async {
    List<FeedData>? currentList = state.itemList;
    int targetIdx = -1;

    if (ref.read(firstFeedDetailStateProvider) != null && currentList != null) {
      if (firstFeedIdx == contentIdx) {
        // 저장 상태를 변경하기 전의 상태를 저장합니다.
        if (!_initialKeepStates.containsKey(contentIdx)) {
          _initialKeepStates[contentIdx] = ref.read(firstFeedDetailStateProvider)!.saveState == 1;
        }

        bool isFirstFeedCurrentlySaved = ref.read(firstFeedDetailStateProvider)!.saveState == 1;

        if (ref.read(firstFeedDetailStateProvider)!.idx == contentIdx) {
          // 저장 상태를 토글합니다.
          ref.read(firstFeedDetailStateProvider.notifier).state = ref.read(firstFeedDetailStateProvider)!.copyWith(
                saveState: isFirstFeedCurrentlySaved ? 0 : 1,
              );

          state.notifyListeners();

          saveKeep = ref.read(firstFeedDetailStateProvider)!.saveState;
        }
      }

      targetIdx = currentList.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        // 저장 상태를 변경하기 전의 상태를 저장합니다.
        if (!_initialKeepStates.containsKey(contentIdx)) {
          _initialKeepStates[contentIdx] = currentList[targetIdx].saveState == 1;
        }

        bool isCurrentlySaved = currentList[targetIdx].saveState == 1;
        currentList[targetIdx] = currentList[targetIdx].copyWith(
          saveState: isCurrentlySaved ? 0 : 1,
        );

        state.notifyListeners();

        saveKeep = currentList[targetIdx].saveState;
      }
    }

    // 각 프로바이더에 대해 추출된 함수 호출
    updateSaveStateForProvider(myFeedStateProvider, contentIdx);
    updateSaveStateForProvider(recentFeedStateProvider, contentIdx);
    updateSaveStateForProvider(followFeedStateProvider, contentIdx);
    updateSaveStateForProvider(popularWeekFeedStateProvider, contentIdx);

    handleSaveAction(
      contentIdx: contentIdx,
      saveState: saveKeep,
    );
  }

  // 각 프로바이더에 대해 반복되는 로직을 처리하는 함수
  void updateSaveStateForProvider(
    ProviderBase provider,
    int contentIdx,
  ) {
    var itemList = ref.read(provider).itemList;
    if (itemList != null) {
      int targetIdx;

      targetIdx = itemList.indexWhere((element) => element.idx == contentIdx);

      if (targetIdx != -1) {
        if (!_initialKeepStates.containsKey(contentIdx)) {
          _initialKeepStates[contentIdx] = itemList[targetIdx].saveState == 1;
        }

        bool isCurrentlySaved;

        isCurrentlySaved = itemList[targetIdx].saveState == 1;

        itemList[targetIdx] = itemList[targetIdx].copyWith(
          saveState: isCurrentlySaved ? 0 : 1,
        );

        ref.read(provider).notifyListeners();

        saveKeep = itemList[targetIdx].saveState;
      }
    }
  }

  void handleSaveAction({
    required int contentIdx,
    required int? saveState,
  }) {
    // 디바운스 타이머 설정

    EasyDebounce.debounce(
      'handleSaveAction',
      const Duration(
        milliseconds: 500,
      ),
      () async {
        // 초기 상태와 현재 상태를 비교합니다.
        bool initialKeepState = _initialKeepStates[contentIdx] ?? false;
        if (saveState == 1 && !initialKeepState) {
          // 저장 상태가 되었다면 API 호출
          await postSave(contentIdx: contentIdx);
        } else if (saveState == 0 && initialKeepState) {
          // 저장 취소 상태가 되었다면 API 호출
          await deleteSave(contentIdx: contentIdx);
        }
        // 처리 후 초기 상태 정보 삭제
        _initialKeepStates.remove(contentIdx);
        saveKeep = null;
      },
    );
  }
}
