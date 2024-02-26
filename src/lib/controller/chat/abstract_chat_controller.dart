import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';

abstract class AbstractChatController {
  Future<void> connect({
    required String url,
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
  });

  Future<void> send({required String msg});

  Future<void> read({
    required String msg,
    required String score,
    required String memberUuid,
  });

  Future<void> disconnect();
}
