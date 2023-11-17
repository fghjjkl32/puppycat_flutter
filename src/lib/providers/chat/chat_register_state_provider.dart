///NOTE
///2023.11.17.
///채팅 교체 예정으로 일단 전체 주석 처리
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';
// import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
// import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_login_state_provider.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'chat_register_state_provider.g.dart';
//
// enum ChatControllerStatus {
//   none,
//   registerSuccess,
//   registerFailure,
//   nickSuccess,
//   nickFailure,
// }
//
// // final accountRestoreProvider = StateProvider.family<Future<bool>, (String, String)>((ref, restoreInfo) {
// //   return ref.read(accountRepositoryProvider).restoreAccount(restoreInfo.$1, restoreInfo.$2);
// // });
//
// class ChatControllerInfo {
//   final String? provider;
//   final String? clientName;
//
//   ChatControllerInfo({
//     this.provider,
//     this.clientName,
//   });
// }
//
// final chatControllerProvider = StateProvider.family<ChatController, ChatControllerInfo>((ref, chatControllerInfo) {
//   // ChatController chatController = ChatController(provider: provider);
//
//   return ChatController(provider: chatControllerInfo.provider ?? 'matrix', clientName: chatControllerInfo.clientName ?? 'puppycat_0');
// });
//
// final chatRegisterInfoProvider = StateProvider<ChatUserModel?>((ref) => null);
//
// @Riverpod(keepAlive: true)
// class ChatRegisterState extends _$ChatRegisterState {
//   static int _registRetryCount = 0;
//   @override
//   ChatControllerStatus build() {
//     return ChatControllerStatus.none;
//   }
//
//   Future<ChatUserModel?> register(UserModel userModel, [bool isAutoLogin = true]) async {
//     var chatController = ref.read(chatControllerProvider(ChatControllerInfo(provider: 'matrix', clientName: 'puppycat_${userModel.idx}'))).controller;
//
//     ///TODO
//     ///controller  안에 있는  create~~~ 함수 여기로 빼기
//     var result = await chatController.register(chatController.createAccount(userModel.id, userModel.appKey), chatController.createPassword(userModel.password), userModel.nick);
//
//     print('chat reg pro result $result');
//     if (result == null) {
//       print('run?');
//       _registRetryCount++;
//       if(_registRetryCount >= 3) {
//         _registRetryCount = 0;
//         print('chat register retry failed.');
//         throw 'chat register retry failed.';
//       }
//       register(userModel);
//
//       ///TODO 무한루프 잡을 코드 넣어야하ㅐ
//       return null;
//     }
//
//     ref.read(chatRegisterInfoProvider.notifier).state = result;
//
//     ///TODO
//     ///이건 필요할지 판단 필요
//     state = ChatControllerStatus.registerSuccess;
//
//     if (isAutoLogin) {
//       UserInfoModel userInfoModel = UserInfoModel(
//         userModel: userModel,
//         chatUserModel: ChatUserModel(
//           chatMemberId: result.chatMemberId,
//           homeServer: result.homeServer,
//           deviceId: result.deviceId,
//           accessToken: result.accessToken,
//         ),
//       );
//       ref.read(chatLoginStateProvider.notifier).chatLogin(userInfoModel);
//     }
//     return result;
//   }
// }
