import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/router/router.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_msg_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_room_list_state_provider.g.dart';

final chatRoomListEmptyProvider = StateProvider<bool>((ref) => false);

@Riverpod(keepAlive: true)
class ChatRoomListState extends _$ChatRoomListState {
  StreamSubscription? _subscription;
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  late final ChatRepository _chatRepository = ChatRepository(dio: ref.read(dioProvider));

  @override
  PagingController<int, ChatRoomModel> build() {
    PagingController<int, ChatRoomModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // if (_apiStatus == ListAPIStatus.loading) {
      //   return;
      // }

      _apiStatus = ListAPIStatus.loading;

      var chatRoomDataListModel = await _chatRepository.getChatRoomList(page: pageKey);
      List<ChatRoomModel> chatRoomList = chatRoomDataListModel.list;
      final pagination = chatRoomDataListModel.params.pagination;

      try {
        _lastPage = pagination?.totalPageCount! ?? 0;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = chatRoomList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(chatRoomList);
      } else {
        state.appendPage(chatRoomList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
      ref.read(chatRoomListEmptyProvider.notifier).state = state.itemList?.isEmpty ?? true;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  Future<ChatEnterModel> createChatRoom({
    required String targetMemberUuid,
  }) async {
    try {
      final ChatEnterModel chatEnterModel = await _chatRepository.createRoom(targetMemberUuid: targetMemberUuid, maxUser: 2);
      ref.read(chatMessageStateProvider.notifier).setInitialChatHistory(chatEnterModel.log ?? []);
      return chatEnterModel;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      rethrow;
    } catch (e) {
      print('createChatRoom Error $e');
      rethrow;
    }
  }

  Future<ChatEnterModel> enterChatRoom({
    required String targetMemberUuid,
    required String titleName,
    required String targetProfileImgUrl,
  }) async {
    try {
      final ChatEnterModel chatEnterModel = await _chatRepository.createRoom(targetMemberUuid: targetMemberUuid, maxUser: 2);
      ref.read(chatMessageStateProvider.notifier).setInitialChatHistory(chatEnterModel.log ?? []);

      final router = ref.read(routerProvider);
      router.push('/chatHome/chatRoom', extra: {
        'roomId': chatEnterModel.roomId,
        'nick': titleName,
        'profileImgUrl': targetProfileImgUrl,
        'targetMemberUuid': targetMemberUuid,
      });

      return chatEnterModel;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      rethrow;
    } catch (e) {
      print('createChatRoom Error $e');
      rethrow;
    }
  }

  Future<bool> pinChatRoom({
    required String roomUuid,
    required bool isPin,
  }) async {
    try {
      final pinResult = await _chatRepository.pinChatRoom(roomUuid: roomUuid, isPin: isPin);

      if (pinResult) {
        state.refresh();
      }

      return pinResult;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      return false;
    } catch (e) {
      print('pinChatRoom Error $e');
      return false;
    }
  }
}
