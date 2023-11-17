import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_detail_state.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
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

part 'first_feed_state_provider.g.dart';

final firstFeedEmptyProvider = StateProvider<bool>((ref) => true);

final firstFeedStatusProvider = StateProvider<ListAPIStatus>((ref) => ListAPIStatus.idle);

@Riverpod(keepAlive: true)
class FirstFeedState extends _$FirstFeedState {
  int _lastPage = 0;
  ListAPIStatus apiStatus = ListAPIStatus.idle;

  String? contentType;
  int? contentIdx;
  List<MemberInfoListData>? memberInfo;
  String? imgDomain;
  int? loginMemberIdx;

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
      Future(() {
        ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.loading;
      });
      state.notifyListeners();

      FeedResponseModel searchResult = feedNullResponseModel;

      if (contentType == "myContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myTagContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "userContent" || contentType == "FollowCardContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx, contentIdx: contentIdx!);
      } else if (contentType == "userTagContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myLikeContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "mySaveContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myDetailContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myKeepContent") {
        searchResult = await KeepContentsRepository(dio: ref.read(dioProvider)).getMyKeepContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "searchContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "popularWeekContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "popularHourContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "notificationContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      }

      memberInfo = searchResult.data.memberInfo;
      imgDomain = searchResult.data.imgDomain;

      List<FeedData> searchList = searchResult.data.list
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

      try {
        _lastPage = searchResult.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
        apiStatus = ListAPIStatus.loaded;
        Future(() {
          ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.loaded;
        });
      } else {
        state.appendPage(searchList, nextPageKey);
        apiStatus = ListAPIStatus.loaded;
        Future(() {
          ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.loaded;
        });
      }

      print("---------------------------------------------------------");
      print(apiStatus);
      print("---------------------------------------------------------");

      ref.read(firstFeedEmptyProvider.notifier).state = searchList.isEmpty;

      state.notifyListeners();
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      apiStatus = ListAPIStatus.error;
      state.error = apiException.toString();
    } catch (e) {
      apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  final Map<int, List<FeedData>?> firstFeedStateMap = {};
  final Map<int, List<MemberInfoListData>?> firstFeedMemberInfoStateMap = {};

  void getStateForUser(int userId) {
    state.itemList = firstFeedStateMap[userId ?? 0] ?? [FeedData(idx: 0)];
    memberInfo = firstFeedMemberInfoStateMap[userId ?? 0] ?? [MemberInfoListData()];

    state.notifyListeners();
  }

  void saveStateForUser(int userId) {
    firstFeedStateMap[userId ?? 0] = state.itemList;
    firstFeedMemberInfoStateMap[userId ?? 0] = memberInfo ?? state.itemList?[0].memberInfoList;
  }
}
