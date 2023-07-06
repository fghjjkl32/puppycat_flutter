import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/user/chat_user_register_model.dart';
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

final chatControllerProvider = StateProvider.family<AbstractChatController, String>((ref, provider) {
  switch(provider) {
    case "matrix" :
    default:
      return MatrixChatClientController();
  }
});

final chatRegisterInfoProvider = StateProvider<ChatUserRegisterModel?>((ref) => null);

@Riverpod(keepAlive: true)
class ChatRegisterState extends _$ChatRegisterState {
  @override
  ChatControllerStatus build() {
    return ChatControllerStatus.none;
  }

  Future<ChatUserRegisterModel?> register(String id, String pw, String nick) async {
    var chatController = ref.read(chatControllerProvider('matrix'));
    var result = await chatController.register(id, pw, nick);
    ref.read(chatRegisterInfoProvider.notifier).state = result;
    return result;
  }


}
