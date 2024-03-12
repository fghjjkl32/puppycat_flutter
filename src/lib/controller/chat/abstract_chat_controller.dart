import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';

abstract class AbstractChatController {
  Future<void> connect({
    required String url,
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
    Function(dynamic)? onError,
  });

  Future<void> send({required String msg, String? profileImg, String? msgQueueUuid});

  Future<void> read({
    required String msg,
    required String score,
    required String memberUuid,
  });

  Future<void> report({
    required String msg,
    required String score,
    required String memberUuid,
    String? msgQueueUuid,
  });

  Future<void> disconnect();

  Future<bool> isConnected();

  void setToken(String token);

  Future<void> activate();
}
