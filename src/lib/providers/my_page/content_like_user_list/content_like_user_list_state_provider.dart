import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/content_like_user_list/content_like_user_list_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_like_user_list_state_provider.g.dart';

final contentLikeUserListEmptyProvider = StateProvider<bool>((ref) => true);

@Riverpod(keepAlive: true)
class ContentLikeUserListState extends _$ContentLikeUserListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

  int? contentsIdx;

  @override
  PagingController<int, ContentLikeUserListData> build() {
    PagingController<int, ContentLikeUserListData> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var result = await ContentLikeUserListRepository(dio: ref.read(dioProvider)).getContentLikeUserList(
        contentsIdx: contentsIdx!,
        page: pageKey,
      );

      List<ContentLikeUserListData> feedList = result.data.list
          .map(
            (e) => ContentLikeUserListData(
              nick: e.nick,
              followState: e.followState,
              isBadge: e.isBadge,
              uuid: e.uuid,
              followerCnt: e.followerCnt,
              intro: e.intro,
              profileImgUrl: e.profileImgUrl,
            ),
          )
          .toList();

      try {
        _lastPage = result.data.params!.pagination?.totalPageCount! ?? 0;
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
      ref.read(contentLikeUserListEmptyProvider.notifier).state = feedList.isEmpty;
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
