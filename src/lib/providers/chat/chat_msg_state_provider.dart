import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_msg_state_provider.g.dart';

///TODO
///안쓸 수도 있음
final chatBubbleFocusProvider = StateProvider<int>((ref) => 0);

@Riverpod(keepAlive: true)
class ChatMessageState extends _$ChatMessageState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  List<String> _initialChatHistoryList = [];
  late final ChatRepository _chatRepository = ChatRepository(dio: ref.read(dioProvider));
  late final _myInfo = ref.read(myInfoStateProvider);

  @override
  PagingController<int, ChatMessageModel> build() {
    PagingController<int, ChatMessageModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      ///TODO
      ///여기에 히스토리 가져오는 로직 필요
      List<ChatMessageModel> chatMsgList = [];

      int idxCnt = 0;
      for (var msg in _initialChatHistoryList) {
        List<String> msgSplit = msg.split('|');

        ChatMessageModel chatMessageModel = ChatMessageModel(
          idx: idxCnt++,
          id: '',
          isMine: msgSplit[2] == _myInfo.uuid,
          userID: msgSplit[2],
          nick: msgSplit[1],
          avatarUrl: '',
          msg: msgSplit[3],
          dateTime: '1707853394',
          //DateTime(2024, 02, 14).millisecondsSinceEpoch.toString(),
          // msgSplit[4],
          isEdited: false,
          reaction: 0,
          hasReaction: false,
          isReply: false,
          isRead: false,
          isConsecutively: false,
          isViewTime: true,
        );

        chatMsgList.add(chatMessageModel);
      }

      _initialChatHistoryList = [];

      chatMsgList = List.from(chatMsgList.reversed);

      // try {
      //   _lastPage = pagination?.totalPageCount! ?? 0;
      // } catch (_) {
      _lastPage = 1;
      // }

      final nextPageKey = pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(chatMsgList);
      } else {
        state.appendPage(chatMsgList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void setInitialChatHistory(List<String> history) {
    _initialChatHistoryList = [];
    _initialChatHistoryList = history;
    if (state.itemList != null) {
      state.refresh();
    }
  }

  void addChatMessage(ChatMessageModel chatMessageModel) {
    int idxCnt = 1;

    if (state.itemList != null) {
      if (state.itemList!.isNotEmpty) {
        idxCnt = state.itemList!.last.idx + 1;
      }
    }

    ChatMessageModel msg = chatMessageModel.copyWith(
      idx: idxCnt,
      isMine: chatMessageModel.userID == _myInfo.uuid,
    );

    print('msg time ${msg.dateTime}');
    // print('isMine ${msg.isMine} / ${chatMessageModel.userID} / ${_myInfo.uuid}');
    if (state.itemList != null) {
      // state.itemList!.add(msg);
      state.itemList!.insert(0, msg);
      // List<ChatMessageModel> msgList = List.from(state.itemList!.reversed);
    }

    state.notifyListeners();
  }

  ///NOTE
  ///채팅 화면에서 날짜 블록을 보여줄지 판단하는 함수
  bool checkViewDateBlock(int index) {
    final chatList = state.itemList;

    /// 채팅 내역이 없으면 날짜 표시
    if (chatList == null) {
      return true;
    }

    if (chatList.length <= index + 1) {
      return true;
    }

    if (index < 0) {
      return false;
    }

    try {
      /// NOTE
      /// Next 가 이전 메시지

      DateTime curMsgDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(chatList[index].dateTime) * 1000);
      DateTime nextMsgDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(chatList[index + 1].dateTime) * 1000);

      DateTime curDateTime = DateTime(curMsgDateTime.year, curMsgDateTime.month, curMsgDateTime.day);
      DateTime nextDateTime = DateTime(nextMsgDateTime.year, nextMsgDateTime.month, nextMsgDateTime.day);

      // print('curDateTime $curDateTime / nextDateTime $nextDateTime / curDateTime.isAfter(nextDateTime) ${curDateTime.isAfter(nextDateTime)}');
      if (curDateTime.isAfter(nextDateTime)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  ///NOTE
  ///채팅 메시지 옆에 시간을 표시해야하는지 판단하는 함수
  bool checkNeedViewTime(int index) {
    final chatList = state.itemList;

    if (chatList == null) {
      return false;
    }

    if (index < 0) {
      return false;
    }

    if (chatList[index] == chatList.first) {
      return true;
    }

    try {
      /// NOTE
      /// Next 가 다음 메시지
      ChatMessageModel curChatMsg = chatList[index];
      ChatMessageModel nextChatMsg = chatList[index - 1];

      DateTime curMsgDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(curChatMsg.dateTime) * 1000);
      DateTime nextMsgDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(nextChatMsg.dateTime) * 1000);

      if (curChatMsg.userID == nextChatMsg.userID) {
        // if (curMsgDateTime.sameOneMinute(nextMsgDateTime)) {
        //   return true;
        // }
        // return false;
        return curMsgDateTime.sameOneMinute(nextMsgDateTime);
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  ///NOTE
  ///채팅 메시지를 동일 사용자가 연속으로 보낸 것인지 체크하는 함수
  bool checkConsecutively(int index) {
    final chatList = state.itemList;

    if (chatList == null) {
      return false;
    }

    if (chatList.length <= index + 1) {
      return false;
    }

    if (index < 0) {
      return false;
    }

    if (chatList[index] == chatList.last) {
      return false;
    }

    try {
      /// NOTE
      /// Next 가 이전 메시지
      ChatMessageModel curChatMsg = chatList[index];
      ChatMessageModel nextChatMsg = chatList[index + 1];

      DateTime curMsgDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(curChatMsg.dateTime) * 1000);
      DateTime nextMsgDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(nextChatMsg.dateTime) * 1000);

      if (curChatMsg.userID == nextChatMsg.userID) {
        // if (curMsgDateTime.sameOneMinute(nextMsgDateTime)) {
        //   return false;
        // }
        // return true;
        return !curMsgDateTime.sameOneMinute(nextMsgDateTime);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  double getChatMsgBottomPadding(int index) {
    final chatList = state.itemList;

    if (chatList == null) {
      return 2.0;
    }

    if (index < 0) {
      return 2.0;
    }

    // if (chatList[index] == chatList.first) {
    //   return 20.0;
    // }

    try {
      /// NOTE
      /// Next 가 다음 메시지
      ChatMessageModel curChatMsg = chatList[index];
      ChatMessageModel nextChatMsg = chatList[index - 1];

      if (curChatMsg.userID == nextChatMsg.userID) {
        return 2.0;
      }

      return 16.0;
    } catch (e) {
      return 16.0;
    }
  }
}
