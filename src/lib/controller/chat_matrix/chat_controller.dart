//
// import 'package:matrix/matrix.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
//
// class ChatController {
//   static String _provider = '';
//   static String _clientName = '';
//   static late AbstractChatController _chatController;
//
//   AbstractChatController get controller => _chatController;
//   ///TODO
//   /// 나중에 확장성 고려해서 수정해야함
//   Client get client => (_chatController as MatrixChatClientController).client;
//
//   ChatController({required String provider, required String clientName}) {
//     if(_provider == provider) {
//       return;
//     }
//     print('chatcontroller run?');
//     _provider = provider;
//     _clientName = clientName;
//     _chatController = _createChatController(provider, clientName);
//   }
//
//   AbstractChatController _createChatController(String provider, String clientName) {
//     switch(provider) {
//       case "matrix" :
//       default:
//         return MatrixChatClientController(clientName);
//     }
//   }
//
//
//
// }
