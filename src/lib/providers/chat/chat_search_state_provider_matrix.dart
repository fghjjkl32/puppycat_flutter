///NOTE
///2023.11.17.
///채팅 교체 예정으로 일단 전체 주석 처리
// import 'dart:math';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:pet_mobile_social_flutter/providers/dio/api_exception.dart';
// import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
// import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
// import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'chat_search_state_provider.g.dart';
//
// @Riverpod(keepAlive: true)
// class ChatUserSearchState extends _$ChatUserSearchState {
//   int _loginMemberIdx = 0;
//   String _searchWord = '';
//   int _lastPage = 0;
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
//       if (_searchWord.isEmpty || _searchWord == '') {
//         state.itemList = [];
//         return;
//       }
//
//       var searchResult = await SearchRepository(dio: ref.read(dioProvider)).getNickSearchList(
//           memberIdx: _loginMemberIdx,
//           page: pageKey,
//           searchWord: _searchWord,
//           limit: 20);
//
//       var searchList = searchResult.data.list
//           .map(
//             (e) => ChatFavoriteModel(
//               memberIdx: e.memberIdx!,
//               isBadge: e.isBadge!,
//               nick: e.nick ?? 'unknown',
//               profileImgUrl:
//                   '${searchResult.data.imgDomain}${e.profileImgUrl}' ?? '',
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
//     } on APIException catch (apiException) {
//       await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
//       state.error = apiException.toString();
//     } catch (e) {
//       state.error = e;
//     }
//   }
//
//   void searchUser(int memberIdx, String searchWord) {
//     if (memberIdx < 0) {
//       return;
//     }
//     if (searchWord.isEmpty || searchWord == '') {
//       state.itemList = [];
//       return;
//     }
//
//     _loginMemberIdx = memberIdx;
//     _searchWord = searchWord;
//
//     state.refresh();
//   }
//
//   void setFavorite(int memberIdx, String chatMemberId) async {
//     print('memberIdx $memberIdx / chatMemberId $chatMemberId 1');
//     bool result = await ref
//         .read(chatFavoriteStateProvider.notifier)
//         .setChatFavorite(memberIdx, chatMemberId);
//     if (result) {
//       print('memberIdx $memberIdx / chatMemberId $chatMemberId 2');
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
//     int targetIdx = state.itemList!
//         .indexWhere((element) => element.chatMemberId == chatMemberId);
//     // int targetIdx = Random().nextInt(state.itemList!.length ?? 4);
//     print('targetIdx $targetIdx');
//     if (targetIdx >= 0) {
//       print('pre state[targetIdx] ${state.itemList![targetIdx]}');
//       state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
//         favoriteState: isFavorite ? 1 : 0,
//       );
//       print('next state[targetIdx] ${state.itemList![targetIdx]}');
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
