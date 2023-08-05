// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:matrix/matrix.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
// import 'package:pet_mobile_social_flutter/models/params_model.dart';
// import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
// import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:rxdart/rxdart.dart';
//
// part 'chat_search_state_provider.g.dart';
//
// enum ChatSearchStatus {
//   idle,
//   typing,
//   searching,
//   searched,
//   error,
// }
//
// final chatSearchStatusProvider = StateProvider<ChatSearchStatus>((ref) => ChatSearchStatus.idle);
// final chatSearchPageProvider = StateProvider<int>((ref) => 0);
// // final chatSearchLastPageProvider = StateProvider<bool>((ref) => false);
// final chatSearchTotalCountProvider = StateProvider<int>((ref) => 0);
// final chatFavoriteStateChangedProvider = StateProvider<ChatFavoriteModel?>((ref) => null);
//
// @Riverpod(keepAlive: true)
// class ChatSearchState extends _$ChatSearchState {
//   int _currentPage = 0;
//   int _lastPage = 1;
//   int searchTotalCount = 0;
//
//   @override
//   List<ChatFavoriteModel> build() {
//     return [];
//   }
//
//   Future<SearchResponseModel> getChatSearchList(int memberIdx, int page, String searchWord) async {
//     try {
//       if (searchWord.isEmpty || searchWord == '') {
//         state = [];
//       }
//
//       var searchResult = await SearchRepository().getSearchList(memberIdx: memberIdx, page: page, searchWord: searchWord, limit: 20);
//
//
//
//       state = [
//         ...state,
//         ...searchResult.data.list
//             .map(
//               (e) => ChatFavoriteModel(
//                 memberIdx: e.memberIdx!,
//                 isBadge: e.isBadge!,
//                 nick: e.nick ?? 'unknown',
//                 profileImgUrl: e.profileImgUrl ?? '',
//                 favoriteState: e.favoriteState,
//                 chatMemberId: e.chatMemberId ?? '',
//                 chatHomeServer: e.chatHomeServer ?? '',
//                 chatAccessToken: e.chatAccessToken ?? '',
//                 chatDeviceId: e.chatDeviceId ?? '',
//                 introText: e.intro ?? '',
//               ),
//             )
//             .toList()
//       ];
//
//       return searchResult;
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }
//
//   ChatFavoriteModel getFavoriteModel(int memberIdx) {
//     return state.firstWhere((element) => element.memberIdx == memberIdx);
//   }
//
//   void changedFavoriteState(ChatFavoriteModel model, bool isFavorite) {
//     int targetIdx = state.indexWhere((element) => element == model);
//     if(targetIdx > 0) {
//       print('pre state[targetIdx] ${state[targetIdx]}');
//       state[targetIdx] = state[targetIdx].copyWith(
//         favoriteState: isFavorite ? 1 : 0,
//       );
//       print('next state[targetIdx] ${state[targetIdx]}');
//     }
//   }
//
//   void setSearchFavorite(int memberIdx, int targetIdx) async {
//     print('setSearchFavorite');
//     final targetModel = getFavoriteModel(targetIdx);
//     bool result = await ref.read(chatFavoriteStateProvider.notifier).setChatFavorite(memberIdx, targetModel.chatMemberId);
//     if(result) {
//       changedFavoriteState(targetModel, true);
//       ref.read(chatFavoriteStateChangedProvider.notifier).state = getFavoriteModel(targetIdx);
//       print('setSearchFavorite 2 ${getFavoriteModel(targetIdx)}');
//     }
//   }
//   void unSetSearchFavorite(int memberIdx, int targetIdx) async {
//     print('unSetSearchFavorite');
//     final targetModel = getFavoriteModel(targetIdx);
//     bool result = await ref.read(chatFavoriteStateProvider.notifier).unSetChatFavorite(memberIdx, targetModel.chatMemberId);
//     if(result) {
//       changedFavoriteState(targetModel, false);
//       ref.read(chatFavoriteStateChangedProvider.notifier).state = getFavoriteModel(targetIdx);
//       print('unSetSearchFavorite 2 ${getFavoriteModel(targetIdx)}');
//     }
//   }
//
//   void chatSearchNick(int memberIdx, int page, String searchWord) async {
//     if (ref.read(chatSearchStatusProvider) == ChatSearchStatus.searching) {
//       print('searching ... ');
//       return;
//     }
//     if (searchWord.isEmpty || searchWord == '' || _lastPage == 0) {
//       print('11111111111111 idx $memberIdx / page $page / word $searchWord');
//       // state.clear();
//       ref.read(chatSearchPageProvider.notifier).state = 0;
//       _currentPage = 0;
//       _lastPage = 1;
//       searchTotalCount = 0;
//       state = [];
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       return;
//     }
//     print('_currentPage $_currentPage / _lastPage $_lastPage');
//     if (_currentPage == _lastPage) {
//       print('last Page');
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       return;
//     }
//     print('idx $memberIdx / page $page / word $searchWord');
//
//     ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searching;
//
//     try {
//       var searchResult = await SearchRepository().getSearchList(memberIdx: memberIdx, page: page, searchWord: searchWord, limit: 20);
//       state = [
//         ...state,
//         ...searchResult.data.list
//             .map(
//               (e) => ChatFavoriteModel(
//                 memberIdx: e.memberIdx!,
//                 isBadge: e.isBadge!,
//                 nick: e.nick ?? 'unknown',
//                 profileImgUrl: e.profileImgUrl ?? '',
//                 favoriteState: e.favoriteState,
//                 chatMemberId: e.chatMemberId ?? '',
//                 chatHomeServer: e.chatHomeServer ?? '',
//                 chatAccessToken: e.chatAccessToken ?? '',
//                 chatDeviceId: e.chatDeviceId ?? '',
//                 introText: e.intro ?? '',
//               ),
//             )
//             .toList()
//       ];
//       // print('searchResult.data.params ${searchResult.data!}');
//       _currentPage = searchResult.data.params!.page!;
//       _lastPage = searchResult.data.params!.pagination!.endPage!;
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       ref.read(chatSearchPageProvider.notifier).state = _currentPage;
//       searchTotalCount = searchResult.data.params!.pagination!.totalRecordCount!;
//     } catch (e) {
//       print('aaaaaa $e');
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.error;
//     }
//   }
// }
