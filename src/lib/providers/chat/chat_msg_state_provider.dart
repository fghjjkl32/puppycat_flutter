import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_history_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_msg_state_provider.g.dart';

enum ChatMessageType {
  enter,
  quit,
  talk,
  read,
  del,
  modify,
  report,
}

///TODO
///안쓸 수도 있음
final chatBubbleFocusProvider = StateProvider<int>((ref) => 0);
final chatReadStatusProvider = StateProvider<Map<String, dynamic>>((ref) => {});

@Riverpod(keepAlive: true)
class ChatMessageState extends _$ChatMessageState {
  int _lastPage = 1;
  String _roomUuid = '';
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
      List<ChatMessageModel> chatMsgList = [];
      List<String> rawChatMsgList = [];
      int chatLastPage = _lastPage;

      if (pageKey == 1) {
        rawChatMsgList = _initialChatHistoryList;
      } else {
        final ChatHistoryModel chatHistoryModel = await _chatRepository.getChatHistory(
          roomUuid: _roomUuid,
          page: pageKey,
        );

        chatLastPage = chatHistoryModel.params?.pagination?.totalPageCount ?? 1;
        rawChatMsgList = chatHistoryModel.log ?? [];
      }

      int idxCnt = 1;

      if (state.itemList != null) {
        if (state.itemList!.isNotEmpty) {
          idxCnt = state.itemList!.last.idx + 1;
        }
      }

      for (var msg in rawChatMsgList) {
        Map<String, dynamic> msgMap = jsonDecode(msg);

        if (msgMap['type'] == 'READ') {
          continue;
        }

        String msgText = msgMap['message'] ?? '';

        if (msgMap['type'] == 'REPORT') {
          msgText = '신고한 메시지입니다.';
        }

        ChatMessageModel chatMessageModel = ChatMessageModel(
          idx: idxCnt++,
          id: '',
          type: msgMap['type'],
          isMine: msgMap['senderMemberUuid'] == _myInfo.uuid,
          userID: msgMap['senderMemberUuid'] ?? '',
          nick: msgMap['senderNick'] ?? 'unknown',
          avatarUrl: '',
          msg: msgText,
          //msgMap['message'] ?? '',
          dateTime: msgMap['regDate'],
          score: msgMap['score'],
          isRead: _checkReadState(msgMap['score']),
          originData: msg,

          ///TODO
          isEdited: false,
          reaction: 0,
          hasReaction: false,
          isReply: false,
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
      // https://pet-chat.devlabs.co.kr/v1/chat/room/log?roomUuid=roomUuid&page=2&limit=20

      _lastPage = chatLastPage;
      // }

      final nextPageKey = pageKey + 1;

      print('pagekey $pageKey / chatLastPage $chatLastPage / nextPageKey $nextPageKey');

      if (pageKey == chatLastPage) {
        state.appendLastPage(chatMsgList);
        print('state.itemList!.length ${state.itemList!.length}');
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

  void setInitialChatHistory(List<String> history, String roomUuid, int lastPage) {
    _initialChatHistoryList = [];
    _initialChatHistoryList = history;
    print('lastPage $lastPage');
    _roomUuid = roomUuid;
    _lastPage = lastPage == 0 ? 1 : lastPage;
    if (state.itemList != null) {
      state.refresh();
    }
  }

  bool _checkReadState(String score) {
    final chatMemeberScores = ref.read(chatReadStatusProvider);
    if (chatMemeberScores.isEmpty) {
      return false;
    }

    bool isRead = false;

    ///NOTE
    ///일단 1명이라도 읽었으면 읽음 처리 되도록 (텔레그램 처럼)
    chatMemeberScores.forEach((key, value) {
      print('int.parse(value) ${int.parse(value)} / int.parse(score) ${int.parse(score)}');
      if (int.parse(value) >= int.parse(score)) {
        isRead = true;
      }
    });

    print('isRead $isRead');
    return isRead;
  }

  void addChatMessage(ChatMessageModel chatMessageModel) {
    if (chatMessageModel.type == 'READ') {
      _changeReadStatus(chatMessageModel);
      return;
    }

    if (chatMessageModel.type == 'REPORT') {
      print('aaaaaaaaaa ');
      _changeReportStatus(chatMessageModel);
      return;
    }

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

  void _changeReadStatus(ChatMessageModel chatMessageModel) {
    if (state.itemList == null) {
      return;
    }

    final myInfo = ref.read(myInfoStateProvider);

    if (myInfo.uuid == chatMessageModel.userID) {
      return;
    }

    List<ChatMessageModel> chatList = state.itemList!;
    List<ChatMessageModel> unReadChatList = chatList.where((e) => e.isRead == false).toList();

    for (var chatModel in unReadChatList) {
      final targetIdx = chatList.indexWhere((element) => element.score == chatModel.score);

      if (targetIdx < 0) {
        continue;
      }

      state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
        isRead: true,
      );
    }

    final readScore = ref.read(chatReadStatusProvider.notifier).state[chatMessageModel.userID];
    if (readScore != null && (int.parse(readScore) < int.parse(chatMessageModel.score))) {
      ref.read(chatReadStatusProvider.notifier).state[chatMessageModel.userID] = chatMessageModel.score;
    }

    state.notifyListeners();
  }

  void _changeReportStatus(ChatMessageModel chatMessageModel) {
    if (state.itemList == null) {
      return;
    }

    final myInfo = ref.read(myInfoStateProvider);

    Map<String, dynamic> originJson = jsonDecode(chatMessageModel.originData);
    print('1 originJson $originJson');
    if (originJson.containsKey('actionMemberUuid')) {
      print('2 originJson $originJson');
      if (myInfo.uuid != originJson['actionMemberUuid']) {
        print('3 originJson $originJson');
        return;
      }
    }

    List<ChatMessageModel> chatList = state.itemList!;

    final targetIdx = chatList.indexWhere((element) => element.score == chatMessageModel.score);

    if (targetIdx < 0) {
      return;
    }

    // state.itemList!.remove(state.itemList![targetIdx]);
    state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
      type: 'REPORT',
      msg: '신고한 메시지입니다.',
    );

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

  Future<bool> reportChatMessage({
    required String roomUuid,
    // required String memberUuid,
    required String message,
    required String score,
    required String targetMemberUuid,
  }) async {
    try {
      return await _chatRepository.reportChatMessage(
        roomUuid: roomUuid,
        memberUuid: _myInfo.uuid ?? '',
        message: message,
        score: score,
        targetMemberUuid: targetMemberUuid,
      );
    } on APIException catch (apiException) {
      ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      return false;
    } catch (e) {
      print('reportChatMessage error $e');
      return false;
    }
  }
}
