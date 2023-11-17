///NOTE
///2023.11.17.
///채팅 교체 예정으로 일단 전체 주석 처리
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get_it/get_it.dart';
// import 'package:matrix/matrix.dart';
// import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
// import 'package:pet_mobile_social_flutter/common/util/encrypt/encrypt_util.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';
// import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
// import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'chat_login_state_provider.g.dart';
//
// enum ChatLoginStatus {
//   none,
//   success,
//   failure,
// }
//
//
// @Riverpod(keepAlive: true)
// class ChatLoginState extends _$ChatLoginState {
//   static int _loginRetryCount = 0;
//
//   @override
//   ChatLoginStatus build() {
//     return ChatLoginStatus.none;
//   }
//
//   Future chatLogin(UserInfoModel userInfoModel) async {
//     if(userInfoModel.userModel == null) {
//       ///TODO
//       ///Error or Login X
//       return null;
//     }
//
//     if (userInfoModel.chatUserModel == null) {
//       ref.read(chatRegisterStateProvider.notifier).register(userInfoModel.userModel!);
//       return null;
//     }
//
//     var chatController = ref.read(chatControllerProvider(ChatControllerInfo(provider: 'matrix', clientName: 'puppycat_${userInfoModel.userModel!.idx}')));
//     String id = userInfoModel.chatUserModel!.chatMemberId ?? '';
//     String pw = userInfoModel.userModel!.password ?? '';
//     // String pw = '280922908812135622';
//     String appKey = userInfoModel.userModel!.appKey ?? '';
//
//     if(id.isEmpty || pw.isEmpty) {
//       ///TODO
//       ///Error or Login X
//       return null;
//     }
//
//     if(appKey.isEmpty) {
//       appKey = await GetIt.I.get<UuidUtil>().getUUID();
//       ref.read(userInfoProvider.notifier).state = userInfoModel.copyWith(userModel: userInfoModel.userModel!.copyWith(
//         appKey: appKey,
//       ));
//     }
//
//     try {
//       LoginResponse result = await chatController.controller.login(id, EncryptUtil.getPassAPIEncrypt(pw));
//       // LoginResponse result = await chatController.controller.login(id, pw);
//       ChatUserModel chatUserModel = ChatUserModel(
//         chatMemberId: result.userId,
//         accessToken: result.accessToken,
//         homeServer: result.homeServer,
//         deviceId: result.deviceId,
//       );
//
//       userInfoModel = userInfoModel.copyWith(chatUserModel: chatUserModel);
//       ref.read(userInfoProvider.notifier).state = userInfoModel;
//       ref.read(myInfoStateProvider.notifier).updateMyChatInfo(userInfoModel);
//       state = ChatLoginStatus.success;
//     } catch (e) {
//       print('login failed. e : $e');
//       state = ChatLoginStatus.failure;
//       _loginRetryCount++;
//       if(_loginRetryCount >= 3) {
//         _loginRetryCount = 0;
//         ref.read(chatRegisterStateProvider.notifier).register(userInfoModel.userModel!);
//         throw 'login retry failed, Try Register';
//       }
//       chatLogin(userInfoModel);
//     }
//
//     print('chat login state : $state');
//   }
// }
