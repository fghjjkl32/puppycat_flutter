// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
// import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
//
// final chatUserSearchProvider = StateNotifierProvider<ChatUserSearchNotifier, PagingController<int, ChatFavoriteModel>>(
//   (ref) => ChatUserSearchNotifier(),
// );
//
// class ChatUserSearchNotifier extends StateNotifier<PagingController<int, ChatFavoriteModel>> {
//   ChatUserSearchNotifier() : super(PagingController(firstPageKey: 1)) {
//     state.addPageRequestListener(_fetchPage);
//   }
//
//   int _loginMemberIdx = 0;
//   String _searchWord = '';
//   int _lastPage = 0;
//
//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       if (_searchWord.isEmpty || _searchWord == '') {
//         state.itemList = [];
//         return;
//       }
//
//       var searchResult = await SearchRepository().getSearchList(memberIdx: _loginMemberIdx, page: pageKey, searchWord: _searchWord, limit: 20);
//
//       var searchList = searchResult.data.list
//           .map(
//             (e) => ChatFavoriteModel(
//               memberIdx: e.memberIdx!,
//               isBadge: e.isBadge!,
//               nick: e.nick ?? 'unknown',
//               profileImgUrl: e.profileImgUrl ?? '',
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
//         _lastPage = searchResult.data.params!.pagination!.endPage!;
//       } catch (_) {
//         _lastPage = 1;
//       }
//
//       // final items = List.generate(20, (index) => '검색결과 $index');
//       final nextPageKey = searchList.isEmpty ? null : pageKey + 1;
//
//       if (pageKey == _lastPage) {
//         state.appendLastPage(searchList);
//       } else {
//         state.appendPage(searchList, nextPageKey);
//       }
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
// }
