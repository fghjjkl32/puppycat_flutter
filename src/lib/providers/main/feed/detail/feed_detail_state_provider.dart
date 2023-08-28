import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_detail_state.dart';
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

final feedDetailStateProvider =
    StateNotifierProvider<FeedDetailStateNotifier, FeedDetailState>((ref) {
  final myFeedNotifier = ref.watch(myFeedStateProvider.notifier);
  final popularWeekFeedNotifier =
      ref.watch(popularWeekFeedStateProvider.notifier);
  final recentFeedNotifier = ref.watch(recentFeedStateProvider.notifier);
  final followFeedNotifier = ref.watch(followFeedStateProvider.notifier);

  return FeedDetailStateNotifier(myFeedNotifier, popularWeekFeedNotifier,
      recentFeedNotifier, followFeedNotifier);
});

class FeedDetailStateNotifier extends StateNotifier<FeedDetailState> {
  final MyFeedState myFeedNotifier;
  final PopularWeekFeedStateNotifier bestFeedNotifier;
  final RecentFeedStateNotifier recentFeedNotifier;
  final FollowFeedStateNotifier followFeedNotifier;

  FeedDetailStateNotifier(this.myFeedNotifier, this.bestFeedNotifier,
      this.recentFeedNotifier, this.followFeedNotifier)
      : super(FeedDetailState(
          firstFeedState: const FeedDataListModel(),
          feedListState: const FeedDataListModel(),
        ));

  final Map<int, FeedDetailState> feedStateMap = {};

  void getStateForUser(int userId) {
    state = feedStateMap[userId] ??
        FeedDetailState(
          firstFeedState: const FeedDataListModel(),
          feedListState: const FeedDataListModel(),
        );
  }

  int maxPages = 1;
  int currentPage = 1;
  initPosts({
    int? loginMemberIdx,
    int? memberIdx,
    int? initPage,
    int? contentIdx,
    String? contentType,
    String? searchWord,
  }) async {
    currentPage = 1;

    final page = initPage ?? state.feedListState.page;

    var futures;

    if (contentType == "myContent") {
      futures = Future.wait([
        FeedRepository().getMyContentsDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        FeedRepository().getMyContentsDetailList(
            loginMemberIdx: loginMemberIdx, memberIdx: memberIdx, page: page),
      ]);
    } else if (contentType == "myTagContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        FeedRepository().getMyTagContentsDetailList(
            loginMemberIdx: loginMemberIdx, page: page),
      ]);
    } else if (contentType == "userContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx, contentIdx: contentIdx!),
        FeedRepository().getUserContentsDetailList(
            loginMemberIdx: loginMemberIdx, page: page, memberIdx: memberIdx),
      ]);
    } else if (contentType == "userTagContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        FeedRepository().getUserTagContentDetail(
            loginMemberIdx: loginMemberIdx, page: page, memberIdx: memberIdx!),
      ]);
    } else if (contentType == "myLikeContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        LikeContentsRepository().getLikeDetailContentList(
            loginMemberIdx: loginMemberIdx!, page: page),
      ]);
    } else if (contentType == "mySaveContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        SaveContentsRepository().getSaveDetailContentList(
            loginMemberIdx: loginMemberIdx, page: page),
      ]);
    } else if (contentType == "myDetailContent") {
      futures = Future.wait([
        FeedRepository().getMyContentsDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        Future.value(feedNullResponseModel),
      ]);
    } else if (contentType == "myKeepContent") {
      futures = Future.wait([
        KeepContentsRepository().getMyKeepContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        Future.value(feedNullResponseModel),
      ]);
    } else if (contentType == "searchContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        FeedRepository().getUserHashtagContentDetailList(
          loginMemberIdx: loginMemberIdx,
          searchWord: searchWord!,
          page: page,
        ),
      ]);
    } else if (contentType == "popularWeekContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        FeedRepository().getPopularWeekDetailList(
          loginMemberIdx: loginMemberIdx,
          page: page,
        ),
      ]);
    } else if (contentType == "popularHourContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        FeedRepository().getPopularHourDetailList(
          loginMemberIdx: loginMemberIdx,
          page: page,
        ),
      ]);
    } else if (contentType == "notificationContent") {
      futures = Future.wait([
        FeedRepository().getContentDetail(
            loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!),
        Future.value(feedNullResponseModel),
      ]);
    }

    final results = await futures;

    final firstLists = results[0];
    final lists = results[1];

    maxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(
      feedListState: state.feedListState.copyWith(
          totalCount: lists.data.params!.pagination!.totalRecordCount!),
      firstFeedState: state.firstFeedState.copyWith(
        totalCount: 1,
      ),
    );

    if (lists == null) {
      state = state.copyWith(
        feedListState:
            state.feedListState.copyWith(page: page, isLoading: false),
        firstFeedState:
            state.firstFeedState.copyWith(page: page, isLoading: false),
      );
      return;
    }

    state = state.copyWith(
      feedListState: state.feedListState.copyWith(
        page: page,
        isLoading: false,
        list: lists.data.list,
        memberInfo: lists.data.memberInfo,
        imgDomain: lists.data.imgDomain,
      ),
      firstFeedState: state.firstFeedState.copyWith(
        page: page,
        isLoading: false,
        list: firstLists.data.list,
        memberInfo: firstLists.data.memberInfo,
        imgDomain: firstLists.data.imgDomain,
      ),
    );

    feedStateMap[memberIdx ?? 0] = FeedDetailState(
      firstFeedState: state.firstFeedState.copyWith(
        page: page,
        isLoading: false,
        list: firstLists.data.list,
        memberInfo: firstLists.data.memberInfo,
        imgDomain: firstLists.data.imgDomain,
      ),
      feedListState: state.feedListState.copyWith(
        page: page,
        isLoading: false,
        list: lists.data.list,
        memberInfo: lists.data.memberInfo,
        imgDomain: lists.data.imgDomain,
      ),
    );
  }

  loadMorePost({
    required int? loginMemberIdx,
    required int memberIdx,
    required String contentType,
    String? searchWord,
  }) async {
    if (currentPage >= maxPages) {
      state = state.copyWith(
          feedListState: state.feedListState.copyWith(isLoadMoreDone: true));
      return;
    }

    StringBuffer bf = StringBuffer();

    bf.write(
        'try to request loading ${state.feedListState.isLoading} at ${state.feedListState.page + 1}');
    if (state.feedListState.isLoading) {
      bf.write(' fail');
      return;
    }
    bf.write(' success');
    state = state.copyWith(
        feedListState: state.feedListState.copyWith(
            isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

    var lists;

    if (contentType == "myContent") {
      lists = await FeedRepository().getMyContentsDetailList(
          loginMemberIdx: loginMemberIdx,
          memberIdx: memberIdx,
          page: state.feedListState.page + 1);
    } else if (contentType == "myTagContent") {
      lists = await FeedRepository().getMyTagContentsDetailList(
          loginMemberIdx: loginMemberIdx, page: state.feedListState.page + 1);
    } else if (contentType == "userContent") {
      lists = await FeedRepository().getUserContentsDetailList(
          loginMemberIdx: loginMemberIdx,
          page: state.feedListState.page + 1,
          memberIdx: memberIdx);
    } else if (contentType == "userTagContent") {
      lists = await FeedRepository().getUserTagContentDetail(
          loginMemberIdx: loginMemberIdx!,
          page: state.feedListState.page + 1,
          memberIdx: memberIdx);
    } else if (contentType == "myLikeContent") {
      lists = await LikeContentsRepository().getLikeDetailContentList(
          loginMemberIdx: loginMemberIdx!, page: state.feedListState.page + 1);
    } else if (contentType == "mySaveContent") {
      lists = await SaveContentsRepository().getSaveDetailContentList(
          loginMemberIdx: loginMemberIdx!, page: state.feedListState.page + 1);
    } else if (contentType == "searchContent") {
      lists = await FeedRepository().getUserHashtagContentDetailList(
          loginMemberIdx: loginMemberIdx!,
          searchWord: searchWord!,
          page: state.feedListState.page + 1);
    } else if (contentType == "popularWeekContent") {
      lists = await FeedRepository().getPopularWeekDetailList(
          loginMemberIdx: loginMemberIdx, page: state.feedListState.page + 1);
    } else if (contentType == "popularHourContent") {
      lists = await FeedRepository().getPopularHourDetailList(
          loginMemberIdx: loginMemberIdx, page: state.feedListState.page + 1);
    }

    if (lists == null) {
      state = state.copyWith(
          feedListState: state.feedListState
              .copyWith(isLoadMoreError: true, isLoading: false));
      return;
    }

    if (lists.data.list.isNotEmpty) {
      state = state.copyWith(
          feedListState: state.feedListState.copyWith(
              page: state.feedListState.page + 1,
              isLoading: false,
              list: [...state.feedListState.list, ...lists.data.list]));
      currentPage++;
    } else {
      state = state.copyWith(
        feedListState: state.feedListState.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<void> refresh({
    required int loginMemberIdx,
    required int memberIdx,
    required int contentIdx,
    required String contentType,
  }) async {
    await initPosts(
      loginMemberIdx: loginMemberIdx,
      memberIdx: memberIdx,
      initPage: 1,
      contentIdx: contentIdx,
      contentType: contentType,
    );
    // myFeedNotifier.refresh(loginMemberIdx);
    bestFeedNotifier.refresh(loginMemberIdx);
    recentFeedNotifier.refresh(loginMemberIdx);
    followFeedNotifier.refresh(loginMemberIdx);
    currentPage = 1;
  }

  Future<ResponseModel> postLike({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository()
        .postLike(memberIdx: loginMemberIdx, contentIdx: contentIdx);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: memberIdx,
      contentIdx: contentIdx,
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> deleteLike({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository()
        .deleteLike(memberIdx: loginMemberIdx, contentsIdx: contentIdx);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: memberIdx,
      contentIdx: contentIdx,
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> postSave({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository()
        .postSave(memberIdx: loginMemberIdx, contentIdx: contentIdx);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: memberIdx,
      contentIdx: contentIdx,
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> deleteSave({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository()
        .deleteSave(memberIdx: loginMemberIdx, contentsIdx: contentIdx);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: memberIdx,
      contentIdx: contentIdx,
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> postKeepContents({
    required loginMemberIdx,
    required List<int> contentIdxList,
    required contentType,
  }) async {
    final result = await KeepContentsRepository()
        .postKeepContents(memberIdx: loginMemberIdx, idxList: contentIdxList);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: loginMemberIdx,
      contentIdx: contentIdxList[0],
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> deleteOneKeepContents({
    required loginMemberIdx,
    required contentIdx,
    required contentType,
  }) async {
    final result = await KeepContentsRepository()
        .deleteOneKeepContents(memberIdx: loginMemberIdx, idx: contentIdx);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: loginMemberIdx,
      contentIdx: contentIdx,
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> deleteOneContents({
    required loginMemberIdx,
    required int contentIdx,
    required contentType,
  }) async {
    final result = await FeedRepository()
        .deleteOneContents(memberIdx: loginMemberIdx, idx: contentIdx);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: loginMemberIdx,
      contentIdx: contentIdx,
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> postHide({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository()
        .postHide(memberIdx: loginMemberIdx, contentIdx: contentIdx);

    return result;
  }

  Future<ResponseModel> deleteHide({
    required loginMemberIdx,
    required memberIdx,
    required contentIdx,
    required String contentType,
  }) async {
    final result = await FeedRepository()
        .deleteHide(memberIdx: loginMemberIdx, contentsIdx: contentIdx);

    await refresh(
      loginMemberIdx: loginMemberIdx,
      memberIdx: memberIdx,
      contentIdx: contentIdx,
      contentType: contentType,
    );

    return result;
  }

  Future<ResponseModel> postBlock({
    required memberIdx,
    required blockIdx,
    required contentIdx,
    required contentType,
  }) async {
    final result = await BlockRepository().postBlock(
      memberIdx: memberIdx,
      blockIdx: blockIdx,
    );

    await refresh(
      loginMemberIdx: memberIdx,
      memberIdx: blockIdx,
      contentIdx: contentIdx,
      contentType: contentType,
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
    final result = await FeedRepository().postContentReport(
      reportType: reportType,
      memberIdx: loginMemberIdx,
      contentIdx: contentIdx,
      reportCode: reportCode,
      reason: reason,
    );

    return result;
  }

  Future<ResponseModel> deleteContentReport({
    required String reportType,
    required int loginMemberIdx,
    required int contentIdx,
  }) async {
    final result = await FeedRepository().deleteContentReport(
      reportType: reportType,
      memberIdx: loginMemberIdx,
      contentsIdx: contentIdx,
    );

    return result;
  }

  Future<ResponseModel> postFollow({
    required memberIdx,
    required followIdx,
    required contentsIdx,
    required contentType,
  }) async {
    final result = await FollowRepository()
        .postFollow(memberIdx: memberIdx, followIdx: followIdx);

    await refresh(
      loginMemberIdx: memberIdx,
      memberIdx: followIdx,
      contentIdx: contentsIdx,
      contentType: contentType,
    );
    return result;
  }

  Future<ResponseModel> deleteFollow({
    required memberIdx,
    required followIdx,
    required contentsIdx,
    required contentType,
  }) async {
    final result = await FollowRepository()
        .deleteFollow(memberIdx: memberIdx, followIdx: followIdx);

    await refresh(
      loginMemberIdx: memberIdx,
      memberIdx: followIdx,
      contentIdx: contentsIdx,
      contentType: contentType,
    );

    return result;
  }
}
