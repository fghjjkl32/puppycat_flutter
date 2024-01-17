import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_tag_contents_state_provider.g.dart';

final userTagContentsFeedListEmptyProvider = StateProvider<bool>((ref) => true);
final userTagContentsFeedTotalCountProvider = StateProvider<int>((ref) => 0);
//NOTE 24.01.17
//마이페이지의 태그 컨텐츠 새로고침 할때 마지막에 봤던 유저를 저장하기 위한 변수
final userTagContentsTempUuidProvider = StateProvider<String>((ref) => "");

@Riverpod(keepAlive: true)
class UserTagContentsState extends _$UserTagContentsState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  String? memberUuid;

  final Map<String, List<ContentImageData>> userTagContentStateMap = {};

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

      var result = await FeedRepository(dio: ref.read(dioProvider)).getUserTagContentList(memberUuid: memberUuid!, page: pageKey);

      ref.read(userTagContentsFeedTotalCountProvider.notifier).state = result.params!.pagination?.totalRecordCount! ?? 0;
      ref.read(userTagContentsTempUuidProvider.notifier).state = memberUuid!;

      List<ContentImageData> feedList = result.list
          .map(
            (e) => ContentImageData(
              imgUrl: e.imgUrl,
              idx: e.idx,
              imageCnt: e.imageCnt,
            ),
          )
          .toList();

      userTagContentStateMap[memberUuid!] = feedList;

      try {
        _lastPage = result.params!.pagination?.totalPageCount! ?? 0;
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
      ref.read(userTagContentsFeedListEmptyProvider.notifier).state = feedList.isEmpty;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      _apiStatus = ListAPIStatus.error;
      state.error = apiException.toString();
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void getStateForUserTagContent(String memberUuid) {
    ref.read(userTagContentsTempUuidProvider.notifier).state = memberUuid;

    state.itemList = userTagContentStateMap[memberUuid] ?? [const ContentImageData(idx: 0, imgUrl: '', imageCnt: 0)];
  }
}
