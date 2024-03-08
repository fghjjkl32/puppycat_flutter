import 'dart:async';

import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ChatControllerState extends _$ChatControllerState {
  late final myInfo = ref.read(myInfoStateProvider);

  ChatEnterModel? _chatEnterModel;
  Function()? _onConnected;
  Function(ChatMessageModel)? _onSubscribeCallBack;
  Function(dynamic)? _onError;
  List<String>? _targetMemberList;

  @override
  ChatController? build() {
    return null;
  }

  Future<ChatController?> connect({
    required ChatEnterModel chatEnterModel,
    List<String> targetMemberList = const [],
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
    Function(dynamic)? onError,
  }) async {
    try {
      ChatController chatController = ChatController(
        roomUuid: chatEnterModel.roomUuid,
        memberUuid: myInfo.uuid ?? '',
        targetMemberUuidList: targetMemberList,
        token: chatEnterModel.generateToken,
      );

      await chatController.connect(
        url: chatWSBaseUrl,
        onConnected: onConnected,
        onSubscribeCallBack: onSubscribeCallBack,
        onError: onError,
      );

      final isConnect = await chatController.isConnected();
      print('isConnect $isConnect');
      //
      // final isConnected = await _connection(
      //   onConnected: onConnected,
      //   onSubscribeCallBack: onSubscribeCallBack,
      //   onError: onError,
      // );
      //
      _chatEnterModel = chatEnterModel;
      _onConnected = onConnected;
      _onSubscribeCallBack = onSubscribeCallBack;
      _onError = onError;
      _targetMemberList = targetMemberList;

      // if (!isConnect) {
      //   return null;
      // }

      state = chatController;
      return chatController;
    } catch (e) {
      print('createChatController error : $e');
      return null;
    }
  }

  Future<bool> _connection({
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
    Function(dynamic)? onError,
  }) async {
    // if (state == null) {
    //   return false;
    // }

    final chatController = state;

    await chatController!.connect(
      url: chatWSBaseUrl,
      onConnected: onConnected,
      onSubscribeCallBack: onSubscribeCallBack,
      onError: onError,
    );

    final isConnect = await chatController.isConnected();
    print('isConnect $isConnect');
    return await chatController.isConnected();
  }

  Future<bool> reConnection({
    required String token,
  }) async {
    if (state == null) {
      return false;
    }

    ChatController? chatController = state!;
    await chatController.disconnect();

    chatController = await connect(
      chatEnterModel: _chatEnterModel!.copyWith(generateToken: token),
      targetMemberList: _targetMemberList!,
      onConnected: _onConnected,
      onSubscribeCallBack: _onSubscribeCallBack,
      onError: _onError,
    );

    if (chatController == null) {
      return false;
    }

    state = chatController;

    return await chatController.isConnected();
  }

  Future<void> disconnect() async {
    try {
      if (state?.isConnected == true) {
        state?.disconnect();
      }
    } catch (e) {
      print('disconnect error : $e');
    }
  }
}
