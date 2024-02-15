import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';

abstract class AbstractChatController {
  Future<void> connect({
    required String url,
    Function(ChatMessageModel)? onSubscribeCallBack,
  });

  Future<void> send({required String msg});

  Future<void> disconnect();
}
