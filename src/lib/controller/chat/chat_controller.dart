
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';

class ChatController {
  static String _provider = '';
  static late AbstractChatController _chatController;

  AbstractChatController get chatController => _chatController;

  ChatController({required String provider}) {
    if(_provider == provider) {
      return;
    }
    print('chatcontroller run?');
    _provider = provider;
    _chatController = _createChatController(provider);
  }

  AbstractChatController _createChatController(String provider) {
    switch(provider) {
      case "matrix" :
      default:
        return MatrixChatClientController();
    }
  }
}