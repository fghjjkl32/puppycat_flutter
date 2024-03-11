import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/stomp_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';

enum ChatType {
  stomp,
}

class ChatController {
  late AbstractChatController _chatController;
  final String roomUuid;
  final String? token;
  final String memberUuid;
  final List<String> targetMemberUuidList;

  ChatController({
    required this.roomUuid,
    required this.memberUuid,
    this.token,
    required this.targetMemberUuidList,
    ChatType type = ChatType.stomp,
  }) {
    _chatController = createChatController(type);
  }

  AbstractChatController createChatController(ChatType type) {
    AbstractChatController abstractChatController;
    switch (type) {
      case ChatType.stomp:
      default:
        abstractChatController = StompController(
          token: token ?? '',
          roomUuid: roomUuid,
          memberUuid: memberUuid,
          targetMemberUuidList: targetMemberUuidList,
        );
        break;
    }

    return abstractChatController;
  }

  Future<void> connect({
    String? url,
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
    Function(dynamic)? onError,
  }) async {
    await _chatController.connect(
      url: url ?? chatWSBaseUrl,
      onConnected: onConnected,
      onSubscribeCallBack: onSubscribeCallBack,
      onError: onError,
    );
  }

  Future<void> disconnect() async {
    print('2 - _chatController.disconnect();');
    _chatController.disconnect();
  }

  Future<void> send(String msg, String? profileImg) async {
    _chatController.send(msg: msg, profileImg: profileImg);
  }

  Future<void> read({
    required String msg,
    required String score,
    required String memberUuid,
  }) async {
    _chatController.read(msg: msg, score: score, memberUuid: memberUuid);
  }

  Future<void> report({
    required String msg,
    required String score,
    required String memberUuid,
  }) async {
    print('2 - report run?');
    _chatController.report(msg: msg, score: score, memberUuid: memberUuid);
  }

  Future<bool> isConnected() async {
    return _chatController.isConnected();
  }

  void setToken(String token) {
    _chatController.setToken(token);
  }

  Future<void> activate() async {
    _chatController.activate();
  }
}
