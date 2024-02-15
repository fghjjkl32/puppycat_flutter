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

  ChatController({
    required this.roomUuid,
    this.token,
    ChatType type = ChatType.stomp,
  }) {
    _chatController = createChatController(type);
  }

  AbstractChatController createChatController(ChatType type) {
    AbstractChatController abstractChatController;
    switch (type) {
      case ChatType.stomp:
      default:
        abstractChatController = StompController(token: token ?? '', roomUuid: roomUuid);
        break;
    }

    return abstractChatController;
  }

  Future<void> connect(
    String? url,
    Function(ChatMessageModel)? onSubscribeCallBack,
  ) async {
    _chatController.connect(url: url ?? chatWSBaseUrl, onSubscribeCallBack: onSubscribeCallBack);
  }

  Future<void> disconnect() async {
    _chatController.disconnect();
  }

  Future<void> send(String msg) async {
    _chatController.send(msg: msg);
  }
}
