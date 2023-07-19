import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_register_state_provider.g.dart';

enum ChatControllerStatus {
  none,
  registerSuccess,
  registerFailure,
  nickSuccess,
  nickFailure,
}

// final accountRestoreProvider = StateProvider.family<Future<bool>, (String, String)>((ref, restoreInfo) {
//   return ref.read(accountRepositoryProvider).restoreAccount(restoreInfo.$1, restoreInfo.$2);
// });

final chatControllerProvider = StateProvider.family<ChatController, String>((ref, provider) {
  // ChatController chatController = ChatController(provider: provider);
  return ChatController(provider: provider);
});

final chatRegisterInfoProvider = StateProvider<ChatUserModel?>((ref) => null);

@Riverpod(keepAlive: true)
class ChatRegisterState extends _$ChatRegisterState {
  @override
  ChatControllerStatus build() {
    return ChatControllerStatus.none;
  }

  Future<ChatUserModel?> register(UserModel userModel) async {
    var chatController = ref.read(chatControllerProvider('matrix')).controller;
    var result = await chatController.register(chatController.createAccount(userModel.id, userModel.appKey), chatController.createPassword(userModel.password), userModel.nick);
    ref.read(chatRegisterInfoProvider.notifier).state = result;
    return result;
  }
}
