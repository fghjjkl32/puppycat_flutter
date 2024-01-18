///NOTE
///2023.11.17.
///채팅 교체 예정으로 일단 전체 주석 처리
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:pet_mobile_social_flutter/common/common.dart';
// import 'package:pet_mobile_social_flutter/providers/dio/api_exception.dart';
// import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
// import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/follow/follow_repository.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'chat_follow_list_state_provider.g.dart';
//
// final chatFollowListEmptyProvider = StateProvider<bool>((ref) => true);
//
// @Riverpod(keepAlive: true)
// class ChatFollowUserState extends _$ChatFollowUserState {
//   int _lastPage = 0;
//   ListAPIStatus _apiStatus = ListAPIStatus.idle;
//
//   @override
//   PagingController<int, ChatFavoriteModel> build() {
//     PagingController<int, ChatFavoriteModel> pagingController =
//         PagingController(firstPageKey: 1);
//     pagingController.addPageRequestListener(_fetchPage);
//     return pagingController;
//   }
//
//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       if (_apiStatus == ListAPIStatus.loading) {
//         return;
//       }
//
//       _apiStatus = ListAPIStatus.loading;
//
//       var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
//       var searchResult = await FollowRepository(dio: ref.read(dioProvider)).getFollowList(
//         memberIdx: loginMemberIdx,
//         page: pageKey,
//         loginMemberIdx: loginMemberIdx,
//       );
//       var searchList = searchResult.data.list
//           .map(
//             (e) => ChatFavoriteModel(
//               memberIdx: e.followIdx!,
//               isBadge: e.isBadge!,
//               nick: e.followNick ?? 'unknown',
//               profileImgUrl: '${searchResult.data.imgDomain}${e.url}' ?? '',
//               favoriteState: e.favoriteState,
//               chatMemberId: e.chatMemberId ?? '',
//               chatHomeServer: e.chatHomeServer ?? '',
//               chatAccessToken: e.chatAccessToken ?? '',
//               chatDeviceId: e.chatDeviceId ?? '',
//               introText: e.intro ?? '',
//             ),
//           )
//           .toList();
//
//       try {
//         _lastPage = searchResult.data.params!.pagination?.totalPageCount! ?? 0;
//       } catch (_) {
//         _lastPage = 1;
//       }
//
//       final nextPageKey = searchList.isEmpty ? null : pageKey + 1;
//
//       if (pageKey == _lastPage) {
//         state.appendLastPage(searchList);
//       } else {
//         state.appendPage(searchList, nextPageKey);
//       }
//       _apiStatus = ListAPIStatus.loaded;
//       ref.read(chatFollowListEmptyProvider.notifier).state = searchList.isEmpty;
//     } on APIException catch (apiException) {
//       await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
//       _apiStatus = ListAPIStatus.error;
//       state.error = apiException.toString();
//     } catch (e) {
//       _apiStatus = ListAPIStatus.error;
//       state.error = e;
//     }
//   }
//
//   void setFavorite(int memberIdx, String chatMemberId) async {
//     bool result = await ref
//         .read(chatFavoriteStateProvider.notifier)
//         .setChatFavorite(memberIdx, chatMemberId);
//     if (result) {
//       changedFavoriteState(chatMemberId, true);
//     }
//   }
//
//   void unSetFavorite(int memberIdx, String chatMemberId) async {
//     bool result = await ref
//         .read(chatFavoriteStateProvider.notifier)
//         .unSetChatFavorite(memberIdx, chatMemberId);
//     if (result) {
//       changedFavoriteState(chatMemberId, false);
//     }
//   }
//
//   void changedFavoriteState(String chatMemberId, bool isFavorite) {
//     if (chatMemberId.isEmpty || chatMemberId == '') {
//       ///TODO
//       ///Need Error Handling
//       return;
//     }
//     int targetIdx = state.itemList!
//         .indexWhere((element) => element.chatMemberId == chatMemberId);
//     // int targetIdx = Random().nextInt(state.itemList!.length ?? 4);
//     print('targetIdx $targetIdx');
//     if (targetIdx >= 0) {
//       state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
//         favoriteState: isFavorite ? 1 : 0,
//       );
//       state.notifyListeners();
//       if (isFavorite) {
//         ref
//             .read(chatFavoriteUserStateProvider.notifier)
//             .addFavorite(state.itemList![targetIdx]);
//       } else {
//         ref
//             .read(chatFavoriteUserStateProvider.notifier)
//             .removeFavorite(state.itemList![targetIdx]);
//       }
//     }
//   }
// }
