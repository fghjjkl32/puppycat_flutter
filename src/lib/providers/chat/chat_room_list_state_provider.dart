import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/router/router.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_chat_data_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_msg_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_room_list_state_provider.g.dart';

final chatRoomListEmptyProvider = StateProvider<bool>((ref) => false);

@Riverpod(keepAlive: true)
class ChatRoomListState extends _$ChatRoomListState {
  StreamSubscription? _subscription;
  int _lastPage = 0;
  int _currentPageKey = 1;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  late final ChatRepository _chatRepository = ChatRepository(dio: ref.read(dioProvider));

  @override
  PagingController<int, ChatRoomModel> build() {
    PagingController<int, ChatRoomModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<List<ChatRoomModel>> _getChatRoomList(int pageKey) async {
    var chatRoomDataListModel = await _chatRepository.getChatRoomList(page: pageKey);
    List<ChatRoomModel> chatRoomList = chatRoomDataListModel.list;
    chatRoomList = chatRoomList.map((e) => e.copyWith(regDate: '${e.regDate}Z')).toList(); //끝에 Z를 붙여야 UTC로 인식

    final pagination = chatRoomDataListModel.params.pagination;
    _lastPage = pagination?.totalPageCount! ?? 0;

    return chatRoomList;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // if (_apiStatus == ListAPIStatus.loading) {
      //   return;
      // }

      _apiStatus = ListAPIStatus.loading;

      // var chatRoomDataListModel = await _chatRepository.getChatRoomList(page: pageKey);
      // List<ChatRoomModel> chatRoomList = chatRoomDataListModel.list;
      // chatRoomList = chatRoomList.map((e) => e.copyWith(regDate: '${e.regDate}Z')).toList();
      List<ChatRoomModel> chatRoomList = await _getChatRoomList(pageKey);

      chatRoomList = chatRoomList.map((e) {
        if (e.userState == 0) {
          e = e.copyWith(nick: e.nick.isEmpty ? e.nick : '알 수 없음');
        }

        return e;
      }).toList();

      print('chatRoomList $chatRoomList');

      // try {
      //   _lastPage = pagination?.totalPageCount! ?? 0;
      // } catch (_) {
      //   _lastPage = 1;
      // }

      _currentPageKey = pageKey;
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
      int chatLastPage = chatEnterModel.params?.pagination?.totalPageCount ?? 1;

      ref.read(chatMessageStateProvider.notifier).setInitialChatHistory(chatEnterModel.log ?? [], chatEnterModel.roomUuid, chatLastPage);
      print('chatEnterModel ${chatEnterModel.memberScore}');
      Map<String, dynamic> memberScore = Map.from(chatEnterModel.memberScore ?? {});
      print('memberScore $memberScore');
      if (memberScore.isNotEmpty) {
        final myInfo = ref.read(myInfoStateProvider);
        if (memberScore.containsKey(myInfo.uuid)) {
          print('aaa');
          memberScore.remove(myInfo.uuid);
          print('bbb');
        }
        ref.read(chatReadStatusProvider.notifier).state = Map.from(memberScore);
      }

      // ref.read(chatRoomListStateProvider).refresh();

      return chatEnterModel;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      rethrow;
    } catch (e) {
      print('createChatRoom Error $e');
      rethrow;
    }
  }

  Future<ChatEnterModel> reEnterChatRoom({
    required String targetMemberUuid,
  }) async {
    try {
      final ChatEnterModel chatEnterModel = await _chatRepository.createRoom(targetMemberUuid: targetMemberUuid, maxUser: 2);

      return chatEnterModel;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      rethrow;
    } catch (e) {
      print('reEnterChatRoom Error $e');
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
      int chatLastPage = chatEnterModel.params?.pagination?.totalPageCount ?? 1;

      ref.read(chatMessageStateProvider.notifier).setInitialChatHistory(chatEnterModel.log ?? [], chatEnterModel.roomUuid, chatLastPage);
      print('chatEnterModel ${chatEnterModel.memberScore}');
      Map<String, dynamic> memberScore = Map.from(chatEnterModel.memberScore ?? {});
      print('memberScore $memberScore');
      if (memberScore.isNotEmpty) {
        final myInfo = ref.read(myInfoStateProvider);
        if (memberScore.containsKey(myInfo.uuid)) {
          memberScore.remove(myInfo.uuid);
        }
        ref.read(chatReadStatusProvider.notifier).state = memberScore;
      }
      final router = ref.read(routerProvider);
      router.push('/chatHome/chatRoom', extra: {
        'roomUuid': chatEnterModel.roomUuid,
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

  Future<bool> pinChatRoom({required String roomUuid, required bool isPin, bool isRefresh = false}) async {
    try {
      final pinResult = await _chatRepository.pinChatRoom(roomUuid: roomUuid, isPin: isPin);

      if (pinResult && isRefresh) {
        // state.refresh();
        silentRefesh();
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

  Future<bool> updateChatRoom({
    required String roomUuid,
    bool isUpdate = false,
    bool isFavorite = false,
    bool isPin = false,
    bool isDelete = false,
    FirebaseChatDataModel? chatData,
    // FirebaseCloudMessagePayload? payload,
  }) async {
    try {
      List<ChatRoomModel> currentRoomList = state.itemList!;

      final targetRoomIdx = currentRoomList.indexWhere((element) => element.uuid == roomUuid);

      if (isDelete) {
        state.itemList!.removeAt(targetRoomIdx);
        state.notifyListeners();
        return true;
      }

      silentRefesh();
      return true;

      // if (state.itemList == null) {
      //   if (isUpdate) {
      //     state.refresh();
      //   }
      //   return false;
      // }
      //
      // List<ChatRoomModel> currentRoomList = state.itemList!;
      //
      // // ChatRoomModel? targetRoom = currentRoomList.firstWhereOrNull((e) => e.uuid == roomUuid);
      // final targetRoomIdx = currentRoomList.indexWhere((element) => element.uuid == roomUuid);
      //
      // if (targetRoomIdx < 0) {
      //   if (isUpdate) {
      //     final firstChatRoom = currentRoomList.first;
      //     // FirebaseChatDataModel? chatDataModel = payload?.chat;
      //
      //     final nowDateTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      //
      //     String regDateTime;
      //
      //     int? timestamp = int.tryParse(chatData?.regDate ?? nowDateTime.toString());
      //     int score;
      //     int regDate;
      //     if (timestamp != null) {
      //       regDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp.toString()) * 1000).toString().substring(0, 19) + 'Z';
      //       score = timestamp * 1000;
      //       regDate = timestamp;
      //     } else {
      //       final parseDatetime = DateTime.parse(chatData?.regDate ?? DateTime.now().toUtc().toString()).toString();
      //
      //       regDateTime = DateTime.parse(parseDatetime).toString().substring(0, 19) + 'Z';
      //       score = DateTime.parse(parseDatetime).millisecondsSinceEpoch;
      //       regDate = DateTime.parse(parseDatetime).millisecondsSinceEpoch ~/ 1000;
      //     }
      //
      //     ChatRoomModel chatRoomModel = firstChatRoom.copyWith(
      //       uuid: chatData?.roomUuid ?? '',
      //       roomId: chatData?.roomUuid ?? '',
      //       nick: chatData?.senderNick ?? '',
      //       lastMessage: chatData != null
      //           ? ChatLastMessageInfoModel(
      //               message: chatData.message ?? '',
      //               regDate: regDate.toString(),
      //               score: score.toString(),
      //               senderMemberUuid: chatData.senderMemberUuid ?? '',
      //               senderNick: chatData.senderNick ?? '',
      //               type: 'TALK',
      //               roomUuid: chatData.roomUuid ?? '',
      //             )
      //           : null,
      //       profileImgUrl: chatData?.senderMemberProfileImg ?? '',
      //       noReadCount: 1,
      //       regDate: regDateTime,
      //     );
      //
      //     state.itemList!.insert(0, chatRoomModel);
      //     state.notifyListeners();
      //   }
      //   return false;
      // }
      //
      // if (isDelete) {
      //   state.itemList!.removeAt(targetRoomIdx);
      //   state.notifyListeners();
      //   return true;
      // }
      //
      // if (isUpdate) {
      //   if (chatData == null) {
      //     return false;
      //   }
      //
      //   ChatRoomModel targetRoom = currentRoomList.removeAt(targetRoomIdx);
      //   final regDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(chatData.regDate ?? '') * 1000).toString().substring(0, 19) + 'Z';
      //
      //   targetRoom = targetRoom.copyWith(
      //     favoriteState: isFavorite ? 1 : 0,
      //     fixState: isPin ? 1 : 0,
      //     lastMessage: targetRoom.lastMessage?.copyWith(
      //       message: chatData.message ?? '',
      //       regDate: chatData.regDate ?? '',
      //       score: chatData.regDate ?? '',
      //     ),
      //     regDate: regDateTime,
      //     noReadCount: targetRoom.noReadCount + 1,
      //   );
      //   state.itemList!.insert(0, targetRoom);
      // } else {
      //   ChatRoomModel targetRoom = currentRoomList[targetRoomIdx];
      //
      //   state.itemList![targetRoomIdx] = targetRoom.copyWith(
      //     favoriteState: isFavorite ? 1 : 0,
      //     fixState: isPin ? 1 : 0,
      //   );
      // }
      //
      // state.notifyListeners();
      // return true;
    } catch (e) {
      print('updateChatRoom error $e');
      return false;
    }
  }

  Future<bool> exitChatRoom({
    required String roomUuid,
  }) async {
    try {
      final result = await _chatRepository.exitChatRoom(roomUuid: roomUuid);

      // if (result) {
      //   state.refresh();
      // }

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      return false;
    } catch (e) {
      print('exitChatRoom Error $e');
      return false;
    }
  }

  Future<void> silentRefesh() async {
    if (state.itemList == null) {
      state.refresh();
      return;
    }

    final currentRoomList = state.itemList!;
    List<ChatRoomModel> newRoomList = [];

    for (int i = 1; i <= _currentPageKey; i++) {
      newRoomList.addAll(await _getChatRoomList(i));
    }

    final mergedList = mergeLists(currentRoomList, newRoomList);

    state.itemList = mergedList;
    state.notifyListeners();
  }

  List<ChatRoomModel> mergeLists(List<ChatRoomModel> currentRoomList, List<ChatRoomModel> newRoomList) {
    List<ChatRoomModel> mergedList = [];
    List<String> mergedUuidList = [];

    // List B의 요소를 우선 추가합니다.
    for (var element in newRoomList) {
      mergedList.add(element);
      mergedUuidList.add(element.roomId);
    }

    // List A의 요소를 추가하되 List B에 이미 있는 요소는 추가하지 않습니다.
    for (var element in currentRoomList) {
      if (!mergedList.contains(element) && !mergedUuidList.contains(element.roomId)) {
        mergedList.add(element);
      }
    }

    return mergedList;
  }
}
