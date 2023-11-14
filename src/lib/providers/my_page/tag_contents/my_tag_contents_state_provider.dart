import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_tag_contents_state_provider.g.dart';

final myTagContentsFeedListEmptyProvider = StateProvider<bool>((ref) => true);
final myTagContentsFeedTotalCountProvider = StateProvider<int>((ref) => 0);

@Riverpod(keepAlive: true)
class MyTagContentsState extends _$MyTagContentsState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

  @override
  PagingController<int, ContentImageData> build() {
    PagingController<int, ContentImageData> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
      var result = await FeedRepository(dio: ref.read(dioProvider)).getMyTagContentList(loginMemberIdx: loginMemberIdx, page: pageKey);

      ref.read(myTagContentsFeedTotalCountProvider.notifier).state = result.data.params!.pagination!.totalRecordCount!;

      List<ContentImageData> feedList = result.data.list
          .map(
            (e) => ContentImageData(
              imgUrl: e.imgUrl,
              idx: e.idx,
              imageCnt: e.imageCnt,
            ),
          )
          .toList();

      try {
        _lastPage = result.data.params!.pagination!.totalPageCount!;
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
      ref.read(myTagContentsFeedListEmptyProvider.notifier).state = feedList.isEmpty;
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }
}
