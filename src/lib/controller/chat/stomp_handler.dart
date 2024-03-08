import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class StompHandler {
  late StompClient _stompClient;

  StompClient get client => _stompClient;

  static void _noOp([_, __]) {}

  static Future _noOpFuture([_, __]) async {}

  Future<StompClient> connect({
    required String url,
    bool useSockJS = false,
    Duration reconnectDelay = const Duration(seconds: 5),
    Duration heartbeatOutgoing = const Duration(seconds: 5),
    Duration heartbeatIncoming = const Duration(seconds: 5),
    Duration connectionTimeout = Duration.zero,
    Map<String, String>? stompConnectHeaders,
    Map<String, dynamic>? webSocketConnectHeaders,
    StompBeforeConnectCallback? beforeConnect,
    StompFrameCallback? onConnect,
    StompFrameCallback? onDisconnect,
    StompFrameCallback? onStompError,
    StompFrameCallback? onUnhandledFrame,
    StompFrameCallback? onUnhandledMessage,
    StompFrameCallback? onUnhandledReceipt,
    StompWebSocketErrorCallback? onWebSocketError,
    StompWebSocketDoneCallback? onWebSocketDone,
    StompDebugCallback? onDebugMessage,
  }) async {
    if (useSockJS) {
      _stompClient = StompClient(
        config: StompConfig.sockJS(
          url: url,
          // reconnectDelay: Duration.zero,
          // connectionTimeout: Duration(milliseconds: 2000),
          onConnect: onConnect ?? _onConnect,
          beforeConnect: beforeConnect ?? _noOpFuture,
          onWebSocketError: onWebSocketError ?? (reason) => print('onWebSocketError $reason'),
          stompConnectHeaders: stompConnectHeaders,
          webSocketConnectHeaders: webSocketConnectHeaders,
          onDisconnect: onDisconnect ?? (reason) => print('onDisconnect $reason'),
          onDebugMessage: onDebugMessage ?? (value) => onDebugMessage,
          onStompError: onStompError ?? (frame) => print('onStompError $frame'),
          onWebSocketDone: onWebSocketDone ?? () => print('onWebSocketDone'),
          onUnhandledMessage: onUnhandledMessage ?? (reason) => print('onUnhandledMessage $reason'),
          heartbeatIncoming: const Duration(seconds: 25),
          heartbeatOutgoing: const Duration(seconds: 25),
        ),
      );
    } else {
      _stompClient = StompClient(
        config: StompConfig(
          url: url,
          onConnect: onConnect ?? _onConnect,
          beforeConnect: beforeConnect ?? _noOpFuture,
          onWebSocketError: onWebSocketError ?? (reason) => print('onWebSocketError $reason'),
          stompConnectHeaders: stompConnectHeaders,
          webSocketConnectHeaders: webSocketConnectHeaders,
          onDisconnect: onDisconnect ?? (reason) => print('onDisconnect $reason'),
          onDebugMessage: onDebugMessage ?? (value) => onDebugMessage,
          onStompError: onStompError ?? (frame) => print('onStompError $frame'),
          onWebSocketDone: onWebSocketDone ?? () => print('onWebSocketDone'),
          onUnhandledMessage: onUnhandledMessage ?? (reason) => print('onUnhandledMessage $reason'),
          heartbeatIncoming: const Duration(seconds: 25),
          heartbeatOutgoing: const Duration(seconds: 25),
        ),
      );
    }

    return _stompClient;
  }

  void _onConnect(StompFrame frame) {
    print('onConnected!');
  }
}
