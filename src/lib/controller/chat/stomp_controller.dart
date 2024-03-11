import 'dart:convert';

import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/stomp_handler.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:stomp_dart_client/stomp.dart';

class StompController implements AbstractChatController {
  late StompClient _stompClient;
  String token;
  final String roomUuid;
  final String memberUuid;
  final List<String> targetMemberUuidList;
  int _retryCount = 0;

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
    Function(dynamic)? onError,
  }) async {
    print('call????');
    _stompClient = await StompHandler().connect(
      url: url,
      useSockJS: true,
      onConnect: (frame) {
        print('onCooooooooooonnected! $roomUuid');
        _retryCount = 0;
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
                  originData: frame.body!.toString(),

                  ///TODO
                  isEdited: false,
                  reaction: 0,
                  hasReaction: false,
                  isReply: false,
                  isRead: false,
                  isConsecutively: false,
                  isViewTime: true,
                );
                if (msgMap['type'] == 'TALK') {
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
      onStompError: onError ?? (frame) => print('socket error $frame'),
      onWebSocketError: (dynamic error) => print('socket error $error'),
      beforeConnect: () async {
        print('waiting to connect...');
        await Future.delayed(const Duration(milliseconds: 200));
        _retryCount++;

        print('connecting... $token');
      },
      stompConnectHeaders: {'token': token},
      webSocketConnectHeaders: {'token': token},
    );

    _stompClient.activate();
  }

  @override
  Future<void> disconnect() async {
    print('3 - _chatController.disconnect();');
    if (_stompClient.isActive) {
      print('4 - _chatController.disconnect();');
      _stompClient.deactivate();
    }
  }

  @override
  Future<void> send({
    required String msg,
    String? profileImg,
  }) async {
    print('targetMemberUuidList $targetMemberUuidList');
    _stompClient.send(
      destination: '/app/chat/message',
      body: json.encode({
        'type': 'TALK',
        'message': msg,
        'logTargetMemberUuidList': targetMemberUuidList,
        'senderMemberProfileImg': profileImg ?? '',
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
    if (_stompClient.isActive == false) {
      print('stomp client is not active');
      return;
    }
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

  @override
  Future<void> report({
    required String msg,
    required String score,
    required String memberUuid,
  }) async {
    print('msg $msg / score $score / memberUuid $memberUuid');
    Map<String, dynamic> msgMap = jsonDecode(msg);
    msgMap['type'] = 'REPORT';
    msgMap['actionMemberUuid'] = memberUuid;

    print('report msgMap $msgMap');

    _stompClient.send(
      destination: '/app/chat/report/message',
      body: json.encode(msgMap),
      headers: {'token': token},
    );
  }

  @override
  Future<bool> isConnected() async {
    return _stompClient.isActive;
  }
}
