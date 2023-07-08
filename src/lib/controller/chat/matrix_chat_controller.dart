import 'dart:async';
import 'dart:math';

import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/common/util/encrypt/encrypt_util.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/user/chat_user_register_model.dart';

class MatrixChatClientController implements AbstractChatController {
  late Client _chatClient;

  Client get client => _chatClient;

  // MatrixChatClientController([String clientName = 'puppycat', String homeServer = 'https://sns-chat.devlabs.co.kr:8008']) {
  MatrixChatClientController([String clientName = 'puppycat', String homeServer = 'https://dev2.office.uxplus.kr']) {
    print('homeServer $homeServer');
    init(clientName, homeServer);
  }

  void init(String clientName, String homeServer) async {
    _chatClient = Client(clientName);
    await client.checkHomeserver(Uri.parse(homeServer));
  }

  @override
  Future<LoginResponse> login(String id, String pw, [LoginType type = LoginType.mLoginPassword]) async {
    var result = await _chatClient.login(
      type,
      identifier: AuthenticationUserIdentifier(user: id),
      password: pw,
    );
    return result;
  }

  @override
  Future<ChatUserRegisterModel?> register(String id, String pw, String displayName, [AccountKind kind = AccountKind.user]) async {
    if (id.contains('@')) {
      id = id.replaceAll('@', '_');
    }
    if (id.contains('#')) {
      id = id.replaceAll('#', '_');
    }

    var result = await _chatClient
        .register(
      auth: AuthenticationData(
        type: "m.login.dummy",
      ),
      kind: kind,
      username: id,
      password: pw,
    )
        .catchError((obj) {
      return null;
    });

    ///TODO
    ///error  처리 필요
    print('register result : $result');

    if (result == null) {
      return null;
    }

    if (result.accessToken != null) {
      _chatClient.accessToken = result.accessToken;
      setDisplayName(result.userId, displayName);
    }

    ChatUserRegisterModel userRegisterModel = ChatUserRegisterModel(
      chatMemberId: result.userId,
      homeServer: result.homeServer,
      accessToken: result.accessToken,
      deviceId: result.deviceId,
    );

    return userRegisterModel;
  }

  @override
  Future<void> setDisplayName(String id, String nick) async {
    await _chatClient.setDisplayName(id, nick);
  }

  String createAccount(String id, String extra) {
    if (id.contains('@')) {
      id = id.replaceAll('@', '_');
    }
    if (id.contains('#')) {
      id = id.replaceAll('#', '_');
    }

    String subStringExtra;
    if (extra.length > 5) {
      if (extra.contains('-')) {
        subStringExtra = extra.split('-').first;
      } else {
        subStringExtra = extra.substring(0, 5);
      }
    } else {
      subStringExtra = extra;
    }

    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random r = Random();
    String strRandom = String.fromCharCodes(Iterable.generate(5, (_) => ch.codeUnitAt(r.nextInt(ch.length))));

    String strAccount = id + subStringExtra + strRandom;
    print('strAccount $strAccount');
    return strAccount;
  }

  String createPassword(String pw) {
    return EncryptUtil.getPassAPIEncrypt(pw);
  }

  @override
  Future getFavoriteList() {
    // TODO: implement getFavoriteList
    throw UnimplementedError();
  }

  @override
  Future logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<List<Room>> getRoomList() async {
    return _chatClient.rooms;
  }

  Stream<List<Room>> getRoomListStream() {
    StreamController<List<Room>> controller = StreamController();

    _chatClient.onSync.stream.listen((event) {
      controller.add(_chatClient.rooms);
    });

    return controller.stream;
  }

  Future<List<MatrixEvent>> getRoomState(String roomId) async {
    return await _chatClient.getRoomState(roomId);
  }
}
