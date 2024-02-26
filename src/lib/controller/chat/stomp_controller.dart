import 'dart:convert';

import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/stomp_handler.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:stomp_dart_client/stomp.dart';

class StompController implements AbstractChatController {
  late StompClient _stompClient;
  final String token;
  final String roomUuid;
  final String memberUuid;
  final List<String> targetMemberUuidList;

  StompClient get client => _stompClient;

  StompController({
    required this.token,
    required this.roomUuid,
    required this.memberUuid,
    required this.targetMemberUuidList,
  });

  @override
  Future<void> connect({
    required String url,
    Function()? onConnected,
    Function(ChatMessageModel)? onSubscribeCallBack,
  }) async {
    print('call????');
    _stompClient = await StompHandler().connect(
      url: url,
      useSockJS: true,
      onConnect: (frame) {
        print('onCooooooooooonnected!');
        _stompClient.subscribe(
            destination: '/topic/chat/room/$roomUuid',
            callback: (frame) {
              print('received msg : ${frame.body!.toString()}');
              if (onSubscribeCallBack != null) {
                Map<String, dynamic> msgMap = jsonDecode(frame.body!.toString());

                String userId = msgMap['senderMemberUuid'] ?? '';
                if (msgMap['type'] == 'READ') {
                  userId = msgMap['readMemberUuid'] ?? '';
                }

                ChatMessageModel chatMessageModel = ChatMessageModel(
                  idx: 0,
                  id: '',
                  type: msgMap['type'],
                  isMine: false,
                  userID: userId,
                  nick: msgMap['senderNick'] ?? 'unknown',
                  avatarUrl: '',
                  msg: msgMap['message'] ?? '',
                  dateTime: msgMap['regDate'],
                  score: msgMap['score'],

                  ///TODO
                  isEdited: false,
                  reaction: 0,
                  hasReaction: false,
                  isReply: false,
                  isRead: false,
                  isConsecutively: false,
                  isViewTime: true,
                );
                if (msgMap['type'] != 'READ') {
                  read(msg: msgMap['message'] ?? '', score: msgMap['score'] ?? '', memberUuid: memberUuid);
                }
                onSubscribeCallBack(chatMessageModel);
              }
            });

        if (onConnected != null) {
          onConnected();
        }
      },
      onDisconnect: (reason) => print('socket disconnect $reason'),
      onDebugMessage: (value) => print('socket debug msg $value'),
      onStompError: (reason) => print('socket stomp error $reason'),
      onWebSocketError: (dynamic error) => print('socket error $error'),
      beforeConnect: () async {
        print('waiting to connect...');
        await Future.delayed(const Duration(milliseconds: 200));
        print('connecting...');
      },
      stompConnectHeaders: {'token': token},
      webSocketConnectHeaders: {'token': token},
    );

    _stompClient.activate();
  }

  @override
  Future<void> disconnect() async {
    if (_stompClient.isActive) {
      _stompClient.deactivate();
    }
  }

  @override
  Future<void> send({required String msg}) async {
    print('targetMemberUuidList $targetMemberUuidList');
    _stompClient.send(
      destination: '/app/chat/message',
      body: json.encode({
        'type': 'TALK',
        'message': msg,
        'logTargetMemberUuidList': targetMemberUuidList,
      }),
      headers: {'token': token},
    );
  }

  @override
  Future<void> read({
    required String msg,
    required String score,
    required String memberUuid,
  }) async {
    print('msg $msg / score $score / memberUuid $memberUuid');
    _stompClient.send(
      destination: '/app/chat/read/message',
      body: json.encode({
        'type': 'READ',
        'message': msg,
        'score': score,
        'readMemberUuid': memberUuid,
      }),
      headers: {'token': token},
    );
  }
}
