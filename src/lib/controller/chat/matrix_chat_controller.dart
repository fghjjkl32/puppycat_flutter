import 'dart:async';
import 'dart:math';

import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/common/util/encrypt/encrypt_util.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';

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
    try {
      var result = await _chatClient.login(
        type,
        identifier: AuthenticationUserIdentifier(user: id),
        password: pw,
      );

      return result;
    } catch (e) {
      throw 'login failure. (e : $e)';
    }
  }

  @override
  Future<ChatUserModel?> register(String id, String pw, String displayName, [AccountKind kind = AccountKind.user]) async {
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

    ChatUserModel userModel = ChatUserModel(
      chatMemberId: result.userId,
      homeServer: result.homeServer,
      accessToken: result.accessToken,
      deviceId: result.deviceId,
    );

    return userModel;
  }

  @override
  Future<void> setDisplayName(String id, String nick) async {
    await _chatClient.setDisplayName(id, nick);
  }

  @override
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

  @override
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
  List<ChatRoomModel> getRoomList() {
    return _chatClient.rooms
        .map(
          (e) => ChatRoomModel(
            id: e.id,
            avatarUrl: e.avatar?.toString(),
            nick: e.getLocalizedDisplayname(),
            lastMsg: e.lastEvent!.calcUnlocalizedBody(
              hideReply: true,
              hideEdit: true,
              plaintextBody: true,
              removeMarkdown: true,
            ),
            newCount: e.notificationCount,
            isRead: !e.isUnread,
            isPin: e.membership == Membership.invite ? false : e.isFavourite,
            msgDateTime: e.timeCreated.localizedTimeDayDiff(),
            isMine: e.lastEvent?.senderId == client.userID,
            isJoined: e.membership == Membership.join,
          ),
        )
        .toList();
  }

  @override
  Stream<List<ChatRoomModel>> getRoomListStream() {
    StreamController<List<ChatRoomModel>> controller = StreamController();

    _chatClient.onSync.stream.listen((event) {
      print('aaa');
      controller.add(_chatClient.rooms.map((e) {
        if(e.membership == Membership.invite) {
          e.join();
        }

        return ChatRoomModel(
          id: e.id,
          avatarUrl: e.avatar?.toString(),
          nick: e.getLocalizedDisplayname(),
          lastMsg: e.lastEvent!.calcUnlocalizedBody(
            hideReply: true,
            hideEdit: true,
            plaintextBody: true,
            removeMarkdown: true,
          ),
          newCount: e.notificationCount,
          isRead: !e.isUnread,
          isPin: e.membership == Membership.invite ? false : e.isFavourite,
          msgDateTime: e.timeCreated.localizedTimeDayDiff(),
          isMine: e.lastEvent?.senderId == client.userID,
          isJoined: e.membership == Membership.join,
        );
      }).toList());
    });

    return controller.stream;
  }

  Future<List<MatrixEvent>> getRoomState(String roomId) async {
    return await _chatClient.getRoomState(roomId);
  }

  @override
  void leave(String roomId) async {
    await _chatClient.leaveRoom(roomId);
  }

  @override
  void setFavorite(String roomId, bool isFavorite) async {
    await _chatClient.getRoomById(roomId)?.setFavourite(isFavorite);
  }

  @override
  Future<bool> send(String roomId, String msg) async {
    var result = await _chatClient.getRoomById(roomId)?.sendTextEvent(msg.trim());
    return result == null ? false : true;
  }
}
