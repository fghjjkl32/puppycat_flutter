///NOTE
///2023.11.17.
///채팅 교체 예정으로 일단 전체 주석 처리
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:pet_mobile_social_flutter/common/common.dart';
// import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'chat_favorite_state_provider.g.dart';
//
// final chatFavoriteStatusChangedProvider = StateProvider<bool>((ref) => false);
//
// final chatFavoriteListEmptyProvider = StateProvider<bool>((ref) => true);
// final charFavoriteFunctionStateProvider = StateProvider<ListAPIStatus>((ref) => ListAPIStatus.idle);
// /// NOTE
// /// 검색 페이지에서 사용
// @Riverpod(keepAlive: true)
// class ChatFavoriteUserState extends _$ChatFavoriteUserState {
//   int _lastPage = 0;
//   ListAPIStatus _apiStatus = ListAPIStatus.idle;
//
//   @override
//   PagingController<int, ChatFavoriteModel> build() {
//     PagingController<int, ChatFavoriteModel> pagingController = PagingController(firstPageKey: 1);
//     pagingController.addPageRequestListener(_fetchPage);
//     return pagingController;
//   }
//
//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       if(_apiStatus == ListAPIStatus.loading) {
//         return;
//       }
//
//       _apiStatus = ListAPIStatus.loading;
//
//       ChatRepository chatRepository = ref.read(chatRepositoryProvider(ref.read(dioProvider)));
//       var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
//       var searchResult = await chatRepository.getChatFavoriteUsers(loginMemberIdx, pageKey);
//
//
//       var searchList = searchResult.list
//           .map(
//             (e) {
//               print('${searchResult.imgDomain} ///  ${e.profileImgUrl}');
//               return ChatFavoriteModel(
//                 memberIdx: e.memberIdx!,
//                 isBadge: e.isBadge!,
//                 nick: e.nick ?? 'unknown',
//                 profileImgUrl: '${searchResult.imgDomain}${e.profileImgUrl}' ?? '',
//                 favoriteState: e.favoriteState,
//                 chatMemberId: e.chatMemberId ?? '',
//                 chatHomeServer: e.chatHomeServer ?? '',
//                 chatAccessToken: e.chatAccessToken ?? '',
//                 chatDeviceId: e.chatDeviceId ?? '',
//                 introText: e.introText ?? '',
//               );
//             })
//           .toList();
//
//
//       try {
//         _lastPage = searchResult.params!.pagination?.totalPageCount! ?? 0;
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
//       ref.read(chatFavoriteListEmptyProvider.notifier).state = searchList.isEmpty;
//     } catch (e) {
//       _apiStatus = ListAPIStatus.error;
//       state.error = e;
//     }
//   }
//
//   void setFavorite(int memberIdx, String chatMemberId) async {
//     bool result = await ref.read(chatFavoriteStateProvider.notifier).setChatFavorite(memberIdx, chatMemberId);
//     if(result) {
//       changedFavoriteState(chatMemberId, true);
//     }
//   }
//   void unSetFavorite(int memberIdx, String chatMemberId) async {
//     bool result = await ref.read(chatFavoriteStateProvider.notifier).unSetChatFavorite(memberIdx, chatMemberId);
//     if(result) {
//       changedFavoriteState(chatMemberId, false);
//     }
//   }
//
//   void changedFavoriteState(String chatMemberId, bool isFavorite) {
//     int targetIdx = state.itemList!.indexWhere((element) => element.chatMemberId == chatMemberId);
//     // int targetIdx = Random().nextInt(state.itemList!.length ?? 4);
//     print('targetIdx $targetIdx');
//     if(targetIdx >= 0) {
//       if(isFavorite) {
//         state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
//           favoriteState: isFavorite ? 1 : 0,
//         );
//       } else {
//         state.itemList!.removeAt(targetIdx);
//       }
//       state.notifyListeners();
//     }
//   }
//
//   void addFavorite(ChatFavoriteModel model) {
//     try {
//       state.itemList?.add(model);
//       state.notifyListeners();
//     } catch(e) {
//       print('add Favorite Error $e');
//     }
//   }
//
//   void removeFavorite(ChatFavoriteModel model) {
//     try {
//       state.itemList?.removeWhere((element) => element.chatMemberId == model.chatMemberId);
//       state.notifyListeners();
//     } catch (e) {
//       print('remove Favorite Error $e');
//     }
//   }
// }
//
// ///NOTE
// ///채팅 방 목록 페이지에서 사용
// @Riverpod(keepAlive: true)
// class ChatFavoriteState extends _$ChatFavoriteState {
//   @override
//   List<ChatFavoriteModel> build() {
//     return [];
//   }
//
//   void getChatFavorite(int memberIdx) async {
//     ChatRepository chatRepository = ref.read(chatRepositoryProvider(ref.read(dioProvider)));
//
//     state = await chatRepository.getChatFavorite(memberIdx);
//     ref.read(chatFavoriteStatusChangedProvider.notifier).state = false;
//   }
//
//   Future<bool> setChatFavorite(int memberIdx, String chatMemberId) async {
//     ChatRepository chatRepository = ref.read(chatRepositoryProvider(ref.read(dioProvider)));
//
//     bool result = await chatRepository.setChatFavorite(memberIdx, chatMemberId);
//
//     getChatFavorite(memberIdx);
//     ref.read(chatFavoriteStatusChangedProvider.notifier).state = result;
//     return result;
//   }
//
//   Future<bool> unSetChatFavorite(int memberIdx, String chatMemberId) async {
//     ChatRepository chatRepository = ref.read(chatRepositoryProvider(ref.read(dioProvider)));
//
//     bool result = await chatRepository.unSetChatFavorite(memberIdx, chatMemberId);
//
//     getChatFavorite(memberIdx);
//     ref.read(chatFavoriteStatusChangedProvider.notifier).state = result;
//     return result;
//   }
// }
