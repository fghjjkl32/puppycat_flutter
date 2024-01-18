import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/follow/follow_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/follow/follow_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_follow_list_state_provider.g.dart';

final chatFollowListEmptyProvider = StateProvider<bool>((ref) => true);

@Riverpod(keepAlive: true)
class ChatFollowUserState extends _$ChatFollowUserState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

  @override
  PagingController<int, FollowData> build() {
    PagingController<int, FollowData> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      final myInfo = ref.read(myInfoStateProvider);
      var searchResult = await FollowRepository(dio: ref.read(dioProvider)).getFollowList(
        memberUuid: myInfo.uuid ?? '',
        page: pageKey,
      );

      var searchList = searchResult.list;

      try {
        _lastPage = searchResult.params!.pagination?.totalPageCount! ?? 0;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
      ref.read(chatFollowListEmptyProvider.notifier).state = searchList.isEmpty;
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
