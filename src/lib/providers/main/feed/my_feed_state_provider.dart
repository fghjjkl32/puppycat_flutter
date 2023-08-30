import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_feed_state_provider.g.dart';

final myFeedListEmptyProvider = StateProvider<bool>((ref) => true);

@Riverpod(keepAlive: true)
class MyFeedState extends _$MyFeedState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

  List<FeedMemberInfoListData>? memberInfo;
  String? imgDomain;

  @override
  PagingController<int, FeedData> build() {
    PagingController<int, FeedData> pagingController =
        PagingController(firstPageKey: 1);
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
      var searchResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetailList(
        loginMemberIdx: loginMemberIdx,
        memberIdx: loginMemberIdx,
        page: pageKey,
      );
      memberInfo = searchResult.data.memberInfo;
      imgDomain = searchResult.data.imgDomain;

      var searchList = searchResult.data.list
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
      } else {
        state.appendPage(searchList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
      ref.read(myFeedListEmptyProvider.notifier).state = searchList.isEmpty;
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  // void setFavorite(int memberIdx, String chatMemberId) async {
  //   bool result = await ref
  //       .read(chatFavoriteStateProvider.notifier)
  //       .setChatFavorite(memberIdx, chatMemberId);
  //   if (result) {
  //     changedFavoriteState(chatMemberId, true);
  //   }
  // }
  //
  // void unSetFavorite(int memberIdx, String chatMemberId) async {
  //   bool result = await ref
  //       .read(chatFavoriteStateProvider.notifier)
  //       .unSetChatFavorite(memberIdx, chatMemberId);
  //   if (result) {
  //     changedFavoriteState(chatMemberId, false);
  //   }
  // }
  //
  // void changedFavoriteState(String chatMemberId, bool isFavorite) {
  //   if (chatMemberId.isEmpty || chatMemberId == '') {
  //     ///TODO
  //     ///Need Error Handling
  //     return;
  //   }
  //   int targetIdx = state.itemList!
  //       .indexWhere((element) => element.chatMemberId == chatMemberId);
  //   // int targetIdx = Random().nextInt(state.itemList!.length ?? 4);
  //   print('targetIdx $targetIdx');
  //   if (targetIdx >= 0) {
  //     state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
  //       favoriteState: isFavorite ? 1 : 0,
  //     );
  //     state.notifyListeners();
  //     if (isFavorite) {
  //       ref
  //           .read(chatFavoriteUserStateProvider.notifier)
  //           .addFavorite(state.itemList![targetIdx]);
  //     } else {
  //       ref
  //           .read(chatFavoriteUserStateProvider.notifier)
  //           .removeFavorite(state.itemList![targetIdx]);
  //     }
  //   }
  // }
}
