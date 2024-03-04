import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';

abstract class AbstractChatController {
  Future<void> connect({
    required String url,
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
    Function()? onWebSocketDone,
  });

  Future<void> send({required String msg, String? profileImg});

  Future<void> read({
    required String msg,
    required String score,
    required String memberUuid,
  });

  Future<void> report({
    required String msg,
    required String score,
    required String memberUuid,
  });

  Future<void> disconnect();
}
