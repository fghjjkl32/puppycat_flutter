import 'dart:async';

import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_msg_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller_state_provider.g.dart';

// @Riverpod(keepAlive: true)
@riverpod
class ChatControllerState extends _$ChatControllerState {
  late final myInfo = ref.read(myInfoStateProvider);

  // ChatEnterModel? _chatEnterModel;
  List<String>? _targetMemberList;

  Map<String, Map<String, dynamic>> _chatMsgQueueMap = {};

  @override
  ChatController? build() {
    return null;
  }

  Future<ChatController?> connect({
    required ChatEnterModel chatEnterModel,
    List<String> targetMemberList = const [],
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
    Function(dynamic)? onError,
  }) async {
    try {
      ChatController chatController = ChatController(
        roomUuid: chatEnterModel.roomUuid,
        memberUuid: myInfo.uuid ?? '',
        targetMemberUuidList: targetMemberList,
        token: chatEnterModel.generateToken,
      );

      await chatController.connect(
        url: chatWSBaseUrl,
        onConnected: onConnected ?? _onConnected,
        onSubscribeCallBack: onSubscribeCallBack ?? _onSubscribeCallBack,
        onError: onError ?? _onError,
      );

      final isConnect = await chatController.isConnected();
      print('isConnect $isConnect');
      //
      // final isConnected = await _connection(
      //   onConnected: onConnected,
      //   onSubscribeCallBack: onSubscribeCallBack,
      //   onError: onError,
      // );
      //
      // _chatEnterModel = chatEnterModel;
      // _onConnected = onConnected;
      // _onSubscribeCallBack = onSubscribeCallBack;
      // _onError = onError;
      print('1 targetMemberList $targetMemberList');
      _targetMemberList = targetMemberList;
      print('2 targetMemberList $_targetMemberList');
      // if (!isConnect) {
      //   return null;
      // }

      state = chatController;
      return chatController;
    } catch (e) {
      print('createChatController error : $e');
      return null;
    }
  }

  Future<bool> reConnection({
    required String token,
  }) async {
    if (state == null) {
      return false;
    }

    ChatController? chatController = state!;

    chatController.setToken(token);
    chatController.activate();
    // await chatController.disconnect();
    //
    // chatController = await connect(
    //   chatEnterModel: _chatEnterModel!.copyWith(generateToken: token),
    //   targetMemberList: _targetMemberList!,
    //   onConnected: _onConnected,
    //   onSubscribeCallBack: _onSubscribeCallBack,
    //   onError: _onError,
    // );

    // if (chatController == null) {
    //   return false;
    // }

    state = chatController;

    return await chatController.isConnected();
  }

  Future<void> disconnect([bool isExit = false]) async {
    try {
      state?.disconnect();

      if (isExit) {
        state = null;
      }
    } catch (e) {
      print('disconnect error : $e');
    }
  }

  void _onConnected() {
    final chatHistoryPagingController = ref.read(chatMessageStateProvider);

    if (chatHistoryPagingController.itemList == null) {
      print('_chatHistoryPagingController.itemList == null');
      return;
    }

    if (chatHistoryPagingController.itemList!.isEmpty) {
      print('_chatHistoryPagingController.itemList.length <= 0');
      return;
    }

    final lastChatModel = chatHistoryPagingController.itemList!.first;
    // final lastChatModel = chatHistoryPagingController.itemList!.firstWhereOrNull((element) => element.type != 'REPORT');
    // print('lastChatModel $lastChatModel');
    // if (lastChatModel != null) {
    state?.read(msg: lastChatModel.msg, score: lastChatModel.score, memberUuid: myInfo.uuid ?? '');
    // }

    // Future.delayed(Duration(milliseconds: 500));
    if (_chatMsgQueueMap.isNotEmpty) {
      _chatMsgQueueMap.forEach((key, value) {
        if (value['type'] == 'TALK') {
          state?.send(value['msg'], value['profileImg'], key);
        } else if (value['type'] == 'REPORT') {
          state?.report(msg: value['msg'], score: value['score'], memberUuid: value['memberUuid'], msgQueueUuid: key);
        }
      });
    }
  }

  void _onSubscribeCallBack(ChatMessageModel chatMessageModel) {
    if (_chatMsgQueueMap.containsKey(chatMessageModel.msgQueueUuid)) {
      _chatMsgQueueMap.remove(chatMessageModel.msgQueueUuid);
    }
    ref.read(chatMessageStateProvider.notifier).addChatMessage(chatMessageModel);
  }

  ///NOTE : onError
  ///정상 종료일 때도 onError가 발생하는 것 확인
  ///메시지가 UNAUTHORIZED 일 때만 재접속을 시도
  Future<void> _onError(dynamic error) async {
    print('onError ${error.headers!.toString()}');
    try {
      Map<String, dynamic> errorMap = error.headers!;
      String message = errorMap['message'] ?? '';

      if (message != 'UNAUTHORIZED') {
        return;
      }

      state!.disconnect();

      ///TODO
      ///이 부분은 고도화 필요
      ///그룹방일 때는 사용 불가
      print('3 targetMemberList $_targetMemberList');
      List<String> targetMemberList = List.from(_targetMemberList ?? []);
      targetMemberList.remove(myInfo.uuid ?? '');

      print('4 targetMemberList $_targetMemberList');
      if (targetMemberList.isEmpty) {
        return;
      }

      String targetMemberUuid = targetMemberList.first.toString();

      final chatEnterModel = await ref.read(chatRoomListStateProvider.notifier).reEnterChatRoom(targetMemberUuid: targetMemberUuid);
      await reConnection(token: chatEnterModel.generateToken);
    } catch (_) {
      return;
    }
  }

  Future<void> sendMessage(String msg, String? profileImg) async {
    final uuid = UuidUtil().generateUuid(v5Key: '$msg${myInfo.uuid}');
    print('msg uuid $uuid / ${uuid.replaceAll('-', '')}');
    uuid.replaceAll('-', '');

    Map<String, dynamic> chatTemp = {
      'type': 'TALK', // 'TALK', 'REPORT
      'msg': msg,
      'profileImg': profileImg ?? '',
    };

    _chatMsgQueueMap[uuid] = chatTemp;

    // final chatMessageModel = ChatMessageModel(
    //   uuid: uuid,
    //   roomUuid: state?.roomUuid ?? '',
    //   senderMemberUuid: myInfo.uuid ?? '',
    //   msg: msg,
    //   profileImg: profileImg,
    //   type: 'TALK',
    //   score: DateTime.now().millisecondsSinceEpoch.toString(),
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    // );

    await state?.send(msg, profileImg, uuid);
  }

  Future<void> reportMessage({
    required String originMsg,
    required String score,
  }) async {
    final uuid = UuidUtil().generateUuid(v5Key: '$score${myInfo.uuid}');
    uuid.replaceAll('-', '');

    Map<String, dynamic> chatTemp = {
      'type': 'REPORT', // 'TALK', 'REPORT
      'msg': originMsg,
      'score': score,
      'memberUuid': myInfo.uuid ?? '',
    };

    _chatMsgQueueMap[uuid.replaceAll('-', '')] = chatTemp;

    await state?.report(
      msg: originMsg,
      score: score,
      memberUuid: myInfo.uuid ?? '',
    );
  }
}
