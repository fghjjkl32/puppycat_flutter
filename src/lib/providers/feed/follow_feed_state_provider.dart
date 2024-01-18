import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/feed/feed_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_feed_state_provider.g.dart';

final followFeedListEmptyProvider = StateProvider<bool>((ref) => true);

@Riverpod(keepAlive: true)
class FollowFeedState extends _$FollowFeedState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

  MemberInfoData? memberInfo;

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

      var feedResult = await FeedRepository(dio: ref.read(dioProvider)).getFollowDetailList(
        page: pageKey,
      );

      memberInfo = feedResult.data!.memberInfo;

      List<dynamic> resultList = feedResult.data!.list;
      List<FeedData> feedList = resultList.map((e) {
        FeedData feedDetail = FeedData.fromJson(e);
        return feedDetail;
      }).toList();

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
      ref.read(followFeedListEmptyProvider.notifier).state = feedList.isEmpty;
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
