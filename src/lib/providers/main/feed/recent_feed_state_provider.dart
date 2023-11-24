import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_feed_state_provider.g.dart';

final recentFeedListEmptyProvider = StateProvider<bool>((ref) => true);

@Riverpod(keepAlive: true)
class RecentFeedState extends _$RecentFeedState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

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
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var feedResult = await FeedRepository(dio: ref.read(dioProvider)).getRecentDetailList(
        loginMemberIdx: loginMemberIdx,
        page: pageKey,
      );

      memberInfo = feedResult.data!.memberInfo;
      imgDomain = feedResult.data!.imgDomain;

      List<FeedData> feedList = feedResult.data!.list
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
        _lastPage = feedResult.data!.params!.pagination?.totalPageCount! ?? 0;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = feedList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(feedList);
      } else {
        state.appendPage(feedList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
      ref.read(recentFeedListEmptyProvider.notifier).state = feedList.isEmpty;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      _apiStatus = ListAPIStatus.error;
      state.error = apiException.toString();
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }
}
