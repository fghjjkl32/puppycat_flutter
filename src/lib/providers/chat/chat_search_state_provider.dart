import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_search_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ChatUserSearchState extends _$ChatUserSearchState {
  int _loginMemberIdx = 0;
  String _searchWord = '';
  int _lastPage = 0;

  @override
  PagingController<int, ChatFavoriteModel> build() {
    PagingController<int, ChatFavoriteModel> pagingController =
        PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_searchWord.isEmpty || _searchWord == '') {
        state.itemList = [];
        return;
      }

      var searchResult = await SearchRepository().getNickSearchList(
          memberIdx: _loginMemberIdx,
          page: pageKey,
          searchWord: _searchWord,
          limit: 20);

      var searchList = searchResult.data.list
          .map(
            (e) => ChatFavoriteModel(
              memberIdx: e.memberIdx!,
              isBadge: e.isBadge!,
              nick: e.nick ?? 'unknown',
              profileImgUrl:
                  '${searchResult.data.imgDomain}${e.profileImgUrl}' ?? '',
              favoriteState: e.favoriteState,
              chatMemberId: e.chatMemberId ?? '',
              chatHomeServer: e.chatHomeServer ?? '',
              chatAccessToken: e.chatAccessToken ?? '',
              chatDeviceId: e.chatDeviceId ?? '',
              introText: e.intro ?? '',
            ),
          )
          .toList();

      try {
        _lastPage = searchResult.data.params!.pagination!.endPage!;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }
    } catch (e) {
      state.error = e;
    }
  }

  void searchUser(int memberIdx, String searchWord) {
    if (memberIdx < 0) {
      return;
    }
    if (searchWord.isEmpty || searchWord == '') {
      state.itemList = [];
      return;
    }

    _loginMemberIdx = memberIdx;
    _searchWord = searchWord;

    state.refresh();
  }

  void setFavorite(int memberIdx, String chatMemberId) async {
    print('memberIdx $memberIdx / chatMemberId $chatMemberId 1');
    bool result = await ref
        .read(chatFavoriteStateProvider.notifier)
        .setChatFavorite(memberIdx, chatMemberId);
    if (result) {
      print('memberIdx $memberIdx / chatMemberId $chatMemberId 2');
      changedFavoriteState(chatMemberId, true);
    }
  }

  void unSetFavorite(int memberIdx, String chatMemberId) async {
    bool result = await ref
        .read(chatFavoriteStateProvider.notifier)
        .unSetChatFavorite(memberIdx, chatMemberId);
    if (result) {
      changedFavoriteState(chatMemberId, false);
    }
  }

  void changedFavoriteState(String chatMemberId, bool isFavorite) {
    int targetIdx = state.itemList!
        .indexWhere((element) => element.chatMemberId == chatMemberId);
    // int targetIdx = Random().nextInt(state.itemList!.length ?? 4);
    print('targetIdx $targetIdx');
    if (targetIdx >= 0) {
      print('pre state[targetIdx] ${state.itemList![targetIdx]}');
      state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
        favoriteState: isFavorite ? 1 : 0,
      );
      print('next state[targetIdx] ${state.itemList![targetIdx]}');
      state.notifyListeners();
      if (isFavorite) {
        ref
            .read(chatFavoriteUserStateProvider.notifier)
            .addFavorite(state.itemList![targetIdx]);
      } else {
        ref
            .read(chatFavoriteUserStateProvider.notifier)
            .removeFavorite(state.itemList![targetIdx]);
      }
    }
  }
}

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
// // final chatSearchPageProvider = StateProvider<int>((ref) => 0);
// // final chatSearchLastPageProvider = StateProvider<bool>((ref) => false);
// // final chatSearchTotalCountProvider = StateProvider<int>((ref) => 0);
// final chatFavoriteStateChangedProvider = StateProvider<ChatFavoriteModel?>((ref) => null);
// final chatSearchPageStateProvider = StateProvider<PagingState<int, ChatFavoriteModel>>((ref) => const PagingState(
//   error: null,
//   nextPageKey: 0,
//   itemList: [],
// ));
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
//       return;
//     }
//     if (searchWord.isEmpty || searchWord == '' || _lastPage == 0 || page == 0) {
//       // ref.read(chatSearchPageProvider.notifier).state = 0;
//       _currentPage = 0;
//       _lastPage = 1;
//       searchTotalCount = 0;
//       state = [];
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       return;
//     }
//     if (_currentPage == _lastPage) {
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       return;
//     }
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
//       // ref.read(chatSearchPageProvider.notifier).state = _currentPage;
//       searchTotalCount = searchResult.data.params!.pagination!.totalRecordCount!;
//     } catch (e) {
//       print('aaaaaa $e');
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.error;
//     }
//   }
//
//   void searchUser(int memberIdx, int pageKey, String searchWord) async {
//     print('memberIdx $memberIdx / $pageKey / $searchWord');
//     if (ref.read(chatSearchStatusProvider) == ChatSearchStatus.searching) {
//       print('searching...');
//       return;
//     }
//     if (searchWord.isEmpty || searchWord == '' || pageKey == 0) {
//       print('searchUser 1');
//       _lastPage = 0;
//       state = [];
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       return;
//     }
//     if (pageKey == _lastPage) {
//       print('searchUser 2');
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       return;
//     }
//
//     print('pageKey $pageKey / $_lastPage' );
//     ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searching;
//
//     try {
//       var searchResult = await SearchRepository().getSearchList(memberIdx: memberIdx, page: pageKey, searchWord: searchWord, limit: 20);
//       print('searchUser 3');
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
//       _lastPage = searchResult.data.params!.pagination!.endPage!;
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.searched;
//       ref.read(chatSearchPageStateProvider.notifier).state = PagingState(
//         error: null,
//         nextPageKey: pageKey + 1,
//         itemList: state,
//       );
//     } catch (e) {
//       print('searchUser 4 $e');
//       ref.read(chatSearchStatusProvider.notifier).state = ChatSearchStatus.error;
//       ref.read(chatSearchPageStateProvider.notifier).state = PagingState(
//         error: e,
//         nextPageKey: pageKey,
//         itemList: state,
//       );
//     }
//   }
// }
